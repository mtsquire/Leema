class WelcomeController < ApplicationController
	layout "home"
  def index
    # sort products by num of orders
    @top_products = Spree::Product.all.sort_by { |p| p.sales_count }.reverse!
    # get randomized list of the top 10
    @top_10_products = @top_products.first(10).shuffle
    # show on product home page
    @products = @top_10_products.first(6)
    @users = User.all
    @suppliers = Spree::Supplier.all

    # predictive search shizzz
    @product_names = []
    @allProducts = Spree::Product.all
    @allProducts.each do |product|
      @product_names << product.name
    end
    File.open("public/productnames.json","w") do |f|
      f.write(@product_names.to_json)
    end

    @supplier_names = []
    @allSuppliers = Spree::Supplier.all
    @allSuppliers.each do |supplier|
      @supplier_names << supplier.store_name
    end
    File.open("public/suppliernames.json","w") do |f|
      f.write(@supplier_names.to_json)
    end

  end

end
