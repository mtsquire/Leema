Spree::Variant.class_eval do
  after_save :add_variant_price, :unless => :is_master?

  def add_variant_price
    if product.price_increase && (product.price_increase_changed? || product.price_increase.new_record?)
      self.price = product.master.price + product.price_increase
    end
  end
end
