class ProfilesController < ApplicationController
  layout "profiles"
  def show  
    @user = User.find_by_display_name(params[:id])
    # wrap this in the if statement so that it doesnt throw 500 errors when user types in
    # leemaeats.com/xxxx
    if @user
      @supplier = @user.supplier
      @orders = @user.spree_orders.all
      if @user.supplier?
        @products = Spree::Product.joins(:suppliers).where('supplier_id = ?', @supplier.id)
      # else
      #   @products = nil
      end
      render action: :show
      @supplier = @user.supplier
      @orders = @user.spree_orders.all
      if @user.supplier?
        @products = Spree::Product.joins(:suppliers).where('supplier_id = ?', @supplier.id)
      # else
      #   @products = nil
      end
    else
      render file: 'public/404', status: 404, layout: false
    end

  end

end
