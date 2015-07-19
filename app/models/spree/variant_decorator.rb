Spree::Variant.class_eval do
  after_create :add_variant_price, :if => :okay_to_increase_variant_price?

  def add_variant_price
    puts 'self.is_master = #{self.is_master}'
    puts 'self.price = #{self.price = product.price + product.price_increase}'
    self.price = product.price + product.price_increase
    puts 'self.price'
    self.save!
  end

  def okay_to_increase_variant_price?
    !self.is_master? &&
    self.id != product.master.id &&
    product.price_increase &&
    product.price_increase > 0 &&
    (product.price_increase_changed? || product.new_record?)
  end
end
