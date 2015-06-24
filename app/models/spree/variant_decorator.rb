Spree::Variant.class_eval do
  # after_save :add_variant_price, :unless => :is_master?

  # def add_variant_price
  #   byebug
  #   if product.price_increase && (product.price_increase_changed? || product.price_increase.new_record?)
  #     puts "before product pice #{product.price}"
  #     puts "adding the variant price..."
  #     variant_price = product.master.price + product.price_increase
  #     self.price = variant_price unless self.is_master?
  #     puts "variant price is = #{variant_price}"
  #     puts "product master price = #{product.master.price}"
  #     puts "product price = #{product.price}"
  #     puts "variant is master? #{self.is_master?}"
  #   end
  # end
  # Ensures a new variant takes the product master price when price is not supplied
      def check_price
        if price.nil? && Spree::Config[:require_master_price]
          raise 'No master variant found to infer price' unless (product && product.master)
          raise 'Must supply price for variant or master.price for product.' if self == product.master
          self.price = product.master.price
        end
        if currency.nil?
          self.currency = Spree::Config[:currency]
        end
        if self != product.master && (product.price_increase_changed? || product.price_increase.new_record?)
          byebug
          self.price = product.master.price + product.price_increase
        end
      end
end
