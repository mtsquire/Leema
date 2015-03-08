Spree::StockItem.class_eval do
  has_one :product, class_name: Spree::Product.to_s
end