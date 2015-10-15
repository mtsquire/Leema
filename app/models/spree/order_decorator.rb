Spree::Order.class_eval do

  has_many :stock_locations, through: :shipments
  has_many :suppliers, through: :stock_locations

    def finalize!
      # lock all adjustments (coupon promotions, etc.)
      all_adjustments.each{|a| a.close}

      # update payment and shipment(s) states, and save
      updater.update_payment_state
      shipments.each do |shipment|
        shipment.update!(self)
        shipment.finalize!
      end

      updater.update_shipment_state
      save
      updater.run_hooks

      touch :completed_at

      deliver_order_confirmation_email unless confirmation_delivered?

      consider_risk
      update_sales_count
    end
    # update the sales count column on the product table
    def update_sales_count
      self.line_items.each do |li|
        li.product.sales_count += li.quantity
        li.product.save
      end
    end

    # Once order is finalized we want to notify the suppliers of their drop ship orders.
    # Here we are handling notification by emailing the suppliers.
    # If you want to customize this you could override it as a hook for notifying a supplier with a API request instead.
    def finalize_with_drop_ship!
      finalize_without_drop_ship!
      shipments.each do |shipment|
        if SpreeDropShip::Config[:send_supplier_email] && shipment.supplier.present?
          begin
            # 'delay' is from a gem which hopefully will solve our problem of emails timing out
            Spree::DropShipOrderMailer.delay.supplier_order(shipment.id)
          rescue => ex #Errno::ECONNREFUSED => ex
            puts ex.message
            puts ex.backtrace.join("\n")
            Rails.logger.error ex.message
            Rails.logger.error ex.backtrace.join("\n")
            return true # always return true so that failed email doesn't crash app.
          end
        end
      end
    end
    alias_method_chain :finalize!, :drop_ship
end 