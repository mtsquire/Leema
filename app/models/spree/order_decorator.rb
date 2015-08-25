Spree::Order.class_eval do
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
    def update_sales_count
      self.products.each do |p|
        byebug
        p.sales_count = p.orders.complete.count
        p.save
      end
    end
end 