class WelcomeController < ApplicationController
	layout "home"
  def index
    @products = Spree::Product.all.shuffle.first(6)
    @images = Spree::Image.all
    @users = User.all
    @suppliers = Spree::Supplier.all

    #predictive search shizzz
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
