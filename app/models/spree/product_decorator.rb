Spree::Product.class_eval do
  belongs_to :user, class_name: Spree.user_class.to_s

  validates :leema_description, presence: true
  validates :ingredients, presence: true
  validates :shipping_information, presence: true

  after_update :increase_variant_price

  def self.search(search)
    if search
      @supplier_search = self.joins(:suppliers).where('store_name LIKE ?', "%#{search}%")
      @product_search = self.where(['name LIKE ? OR leema_description LIKE ?', "%#{search}%", "%#{search}%"])
      if @supplier_search.count > 0
        @supplier_search
      elsif @product_search.count > 0
        @product_search
      end
    else
      @products = Spree::Product.all
    end
  end

  def increase_variant_price
    # if user updates the price increase field, propogate that value to the variant price
    if self.price_increase_changed?
      # the product's last (most recent) variant is the custom order variant. will need to change this
      # if we ever allow more than 1 custom variant.
      variant = self.variants.last
      if variant
        variant.price = self.price_increase + self.price
        variant.save!
      else
        # handle this so the app doesnt bomb out
        puts 'no variant found... woops!'
      end
    end
  end

end