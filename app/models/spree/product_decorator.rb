Spree::Product.class_eval do
  belongs_to :user, class_name: Spree.user_class.to_s

  validates :leema_description, presence: true

  def self.search(search)
    if search
      where(['name ILIKE ?', "%#{search}%"])
    else
      @products = Spree::Product.all
    end
  end

end