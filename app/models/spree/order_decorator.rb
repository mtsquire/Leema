Spree::Order.class_eval do
  # Finalizes an in progress order after checkout is complete.
    # Called after transition to complete state when payments will have been processed
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
      self.products.each do |p|
        p.sales_count ++
      end
    end
end 