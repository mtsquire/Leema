Spree::Order.class_eval do
    def finalize!
      self.products.each do |p|
        byebug
        p.sales_count = p.orders.complete.count
        p.save
      end
    end
end 