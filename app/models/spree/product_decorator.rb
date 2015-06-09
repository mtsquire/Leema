Spree::Product.class_eval do
  belongs_to :user, class_name: Spree.user_class.to_s

  validates :leema_description, presence: true
  validates :ingredients, presence: true
  before_create :assign_option_and_create_variant, :if => :is_custom?

  def self.search(search)
    if search
      where(['name ILIKE ?', "%#{search}%"]) &&
      where(['leema_description ILIKE ?', "%#{search}%" ])
    else
      @products = Spree::Product.all
    end
  end

  # method to detect if product is able to be custom ordered
  def is_custom?
    true if !self.custom_order_description.blank? || self.price_increase > 0
  end

  def assign_option_and_create_variant

  end

  def create_variant
  end

end