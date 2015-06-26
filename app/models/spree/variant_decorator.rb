Spree::Variant.class_eval do
  after_create :add_variant_price, :if => :okay_to_increase_variant_price?

  def add_variant_price
    byebug
    puts 'self.is_master = #{self.is_master}'
    self.price = product.price_increase
    self.save!
    byebug
  end

  def okay_to_increase_variant_price?
    !self.is_master? && self.id != product.master.id && product.price_increase > 0 && (product.price_increase_changed? || product.price_increase.new_record?)
  end
end
