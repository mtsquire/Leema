Spree::Order.class_eval do
    def finalize!
      self.products.each do |p|
        p.sales_count ++
        p.save
      end
    end
end 