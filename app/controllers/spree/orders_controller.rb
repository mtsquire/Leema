module Spree
  class OrdersController < Spree::StoreController
    ssl_required :show
    
    helper 'spree/products', 'spree/orders'

    respond_to :html

    before_filter :assign_order_with_lock, only: :update
    before_filter :apply_coupon_code, only: :update
    skip_before_filter :verify_authenticity_token

    def show
      @order = Order.find_by_number!(params[:id])
    end

    def update
      if @order.contents.update_cart(order_params)
        respond_with(@order) do |format|
          format.html do
            if params.has_key?(:checkout)
              @order.next if @order.cart?
              redirect_to checkout_state_path(@order.checkout_steps.first)
            else
              redirect_to cart_path
            end
          end
        end
      else
        respond_with(@order)
      end
    end

    # Shows the current incomplete order from the session
    def edit
      @order = current_order || Order.new
      associate_user
    end

    # Adds a new item to the order (creating a new order if none already exists)
    def populate
      # adding new custom order fields here, scope with if statement incase user doesnt select custom option
      # if the product variant id is the same as the master id, then we know it isnt a custom order.
      if params.has_key?(:order)
        custom_stuff = [params[:order][:custom_product_description], params[:order][:deliver_by_date]]
      end
      puts "custom stuff = #{custom_stuff}"
      byebug
      populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
      if populator.populate(params[:variant_id], params[:quantity], custom_stuff)
        byebug
        respond_with(@order) do |format|
          format.html { redirect_to cart_path }
        end
      else
        flash[:error] = populator.errors.full_messages.join(" ")
        redirect_back_or_default(spree.root_path)
      end
    end

    def empty
      if @order = current_order
        @order.empty!
      end

      redirect_to spree.cart_path
    end

    def accurate_title
      if @order && @order.completed?
        Spree.t(:order_number, :number => @order.number)
      else
        Spree.t(:shopping_cart)
      end
    end

    def check_authorization
      cookies.permanent.signed[:guest_token] = params[:token] if params[:token]
      order = Spree::Order.find_by_number(params[:id]) || current_order

      if order
        authorize! :edit, order, cookies.signed[:guest_token]
      else
        authorize! :create, Spree::Order
      end
    end

    private

      def order_params
        if params[:order]
          params[:order].permit(*permitted_order_attributes)
        else
          {}
        end
      end

      def assign_order_with_lock
        @order = current_order(lock: true)
        unless @order
          flash[:error] = Spree.t(:order_not_found)
          redirect_to root_path and return
        end
      end
  end
end
