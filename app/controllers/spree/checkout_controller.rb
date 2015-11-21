module Spree
  # This is somewhat contrary to standard REST convention since there is not
  # actually a Checkout object. There's enough distinct logic specific to
  # checkout which has nothing to do with updating an order that this approach
  # is waranted.
  class CheckoutController < Spree::StoreController
    ssl_required

    before_filter :load_order_with_lock

    before_filter :ensure_order_not_completed
    before_filter :ensure_checkout_allowed
    before_filter :ensure_sufficient_stock_lines
    before_filter :ensure_valid_state

    before_filter :associate_user
    before_filter :check_authorization
    before_filter :apply_coupon_code

    before_filter :setup_for_current_state

    helper 'spree/orders'

    rescue_from Spree::Core::GatewayError, :with => :rescue_from_spree_gateway_error

    def edit
      # if the user has a leema account and has ordered before we will prepopulate
      # their billing address
      @previous_address = nil
      if @order.user != nil
        if !@order.user.spree_orders.where(state: "complete").empty?
          @previous_address = @order.user.spree_orders.where(state: "complete").last.bill_address
        end
      end

      @order.shipments.each do |shipment|
        get_shipping_rates(shipment)
      end
    end


    # Updates the order and advances to the next state (when possible.)
    def update
      if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
        @order.temporary_address = !params[:save_user_address]
        unless @order.next
          flash[:error] = @order.errors.full_messages.join("\n")
          redirect_to checkout_state_path(@order.state) and return
        end

        if @order.completed?
          @current_order = nil
          # Transfer money to supplier bank account
          if Rails.env.production?
            charge_id = @order.payments.first.response_code
            @order.shipments.each do |shipment|
              shipment.stripe_charge_id = charge_id
              shipment.save!
              puts "Set stripe charge id to #{shipment.stripe_charge_id}!"
            end
          end
          flash.notice = Spree.t(:order_processed_successfully)
          flash['order_completed'] = true
          redirect_to completion_route
        else
          redirect_to checkout_state_path(@order.state)
        end
      else
        render :edit
      end
    end

    private
      def ensure_valid_state
        unless skip_state_validation?
          if (params[:state] && !@order.has_checkout_step?(params[:state])) ||
             (!params[:state] && !@order.has_checkout_step?(@order.state))
            @order.state = 'cart'
            redirect_to checkout_state_path(@order.checkout_steps.first)
          end
        end

        # Fix for #4117
        # If confirmation of payment fails, redirect back to payment screen
        if params[:state] == "confirm" && @order.payment_required? && @order.payments.valid.empty?
          flash.keep
          redirect_to checkout_state_path("payment")
        end
      end

      # Should be overriden if you have areas of your checkout that don't match
      # up to a step within checkout_steps, such as a registration step
      def skip_state_validation?
        false
      end

      def load_order_with_lock
        @order = current_order(lock: true)
        redirect_to spree.cart_path and return unless @order

        if params[:state]
          redirect_to checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
          @order.state = params[:state]
        end
      end

      def ensure_checkout_allowed
        unless @order.checkout_allowed?
          redirect_to spree.cart_path
        end
      end

      def ensure_order_not_completed
        redirect_to spree.cart_path if @order.completed?
      end

      def ensure_sufficient_stock_lines
        if @order.insufficient_stock_lines.present?
          flash[:error] = Spree.t(:inventory_error_flash_for_insufficient_quantity)
          redirect_to spree.cart_path
        end
      end

      # Provides a route to redirect after order completion
      def completion_route
        spree.order_path(@order)
      end

      def setup_for_current_state
        method_name = :"before_#{@order.state}"
        send(method_name) if respond_to?(method_name, true)
      end

      def before_address
        # if the user has a default address, a callback takes care of setting
        # that; but if he doesn't, we need to build an empty one here
        @order.bill_address ||= Address.build_default
        @order.ship_address ||= Address.build_default if @order.checkout_steps.include?('delivery')
      end

      def before_delivery
        return if params[:order].present?

        packages = @order.shipments.map { |s| s.to_package }
        @differentiator = Spree::Stock::Differentiator.new(@order, packages)
      end

      def before_payment
        if @order.checkout_steps.include? "delivery"
          packages = @order.shipments.map { |s| s.to_package }
          @differentiator = Spree::Stock::Differentiator.new(@order, packages)
          @differentiator.missing.each do |variant, quantity|
            @order.contents.remove(variant, quantity)
          end
        end

        if try_spree_current_user && try_spree_current_user.respond_to?(:payment_sources)
          @payment_sources = try_spree_current_user.payment_sources
        end
      end

      def rescue_from_spree_gateway_error(exception)
        flash.now[:error] = Spree.t(:spree_gateway_error_flash_for_checkout)
        @order.errors.add(:base, exception.message)
        render :edit
      end

      def check_authorization
        authorize!(:edit, current_order, cookies.signed[:guest_token])
      end

      def get_shipping_rates(shipment)
        shipment.line_items.each do |li|
          # Here we are checking to see if we got the 'First' rate back, which only applies to shipments under a certain weight
          if shipment.shipping_rates.where(name: "USPS First").first
            shipment.available_rates[0] = shipment.shipping_rates.where(name: "USPS First").first
          end

          if li.product.allow_usps_priority == 1
            shipment.available_rates[1] = shipment.shipping_rates.where(name: "USPS Priority").first 
            # have to use .first to get a single object, otherwise returns an ActiveRecord
            # Association
          end

          if li.product.allow_usps_express == 1
            shipment.available_rates[2] = shipment.shipping_rates.where(name: "USPS Express").first
            if li.product.allow_usps_priority == 0
              # if the buyer has purchased just one product that needs to be shipped
              # express then we force the buyer to select that option regardless of
              # what the other products' shipping options were.
              shipment.available_rates = {}
              
              shipment.available_rates[1] = shipment.shipping_rates.where(name: "USPS Express").first and return shipment.available_rates
            end
          end
          # error handling in case no rate was checked by supplier, at least give one option
          if shipment.available_rates == {}
            # create a rate with (with key of 1). Bug fixed here when I added = instead of <<
            shipment.available_rates[1] = shipment.shipping_rates.where(name: "USPS Priority").first
          end
        end

      end

      def current_order(options = {})
        options[:create_order_if_necessary] ||= false
        options[:lock] ||= false
        return @current_order if @current_order
        @current_order = find_order_by_token_or_user(options)

        if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
          @current_order = Spree::Order.new(current_order_params)
          @current_order.user ||= current_user
          # See issue #3346 for reasons why this line is here
          @current_order.created_by ||= current_user
          @current_order.save!
        end

        if @current_order
          return @current_order
        end
      end

      def find_order_by_token_or_user(options={})

        # Find any incomplete orders for the guest_token
        order = Spree::Order.incomplete.includes(:adjustments).lock(options[:lock]).find_by(current_order_params)
        # Find any incomplete orders for the current user
        if order.nil? && current_user
          order = Spree::Order.incomplete.order('id DESC').where({ currency: current_currency, user_id: current_user.try(:id)}).first
          # If there is no prior order, find the latest in progress
          # order from the guest and associate it with the newly logged in user
          if !order
            order = Spree::Order.incomplete.find_by({ currency: current_currency, guest_token: cookies.signed[:guest_token], user_id: nil })
          end
        end

        order
      end

  end
end
