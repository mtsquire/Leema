Spree::Product.class_eval do
  belongs_to :user, class_name: Spree.user_class.to_s

  validates :leema_description, presence: true
  validates :ingredients, presence: true
  validates :shipping_information, presence: true

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

end