Spree.user_class.class_eval do

  belongs_to :supplier, class_name: 'Spree::Supplier', dependent: :destroy

  has_many :variants, through: :supplier

  before_destroy :delete_products
  before_destroy :delete_stock_location

  def admin?
    has_spree_role?("admin")
  end
  
  def supplier?
    supplier.present?
  end

  private

  def delete_products
    if self.supplier?
      products = Spree::Product.where("user_id = ?", self.id)
      if products
        products.delete_all
      end
    end
  end
  def delete_stock_location
    if self.supplier?
      if self.supplier.stock_locations
        self.supplier.stock_locations.delete_all
      end
    end
  end

end