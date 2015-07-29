class ProfilesController < ApplicationController
  layout "profiles"
  def show  
    @user = User.find_by_display_name(params[:id])

    if @user
      render action: :show
      @supplier = @user.supplier
      @orders = @user.spree_orders.all
      if @user.supplier?
        @products = Spree::Product.joins(:suppliers).where('supplier_id = ?', @supplier.id)
      # else
      #   @products = nil
      end
    else
      render file: 'public/404', status: 404, format: [:html]
    end

  end

end
