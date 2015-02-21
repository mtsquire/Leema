Spree::Admin::ProductsController.class_eval do
  before_filter :get_suppliers, only: [:edit, :update]
  before_filter :supplier_collection, only: [:index]

  create.after :add_product_to_supplier

  def show
    session[:return_to] ||= request.referer
    redirect_to( :action => :edit )
    @product = Spree::Product.find(params[:id])
    @supplier = @product.suppliers.first
  end

  # Set this up for the search functionality
  def index
    @user = spree_current_user
    @supplier = @user.supplier
    @products = Spree::Product.search(params[:search])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end

    session[:return_to] = request.url
    # Commenting out this line fixed the double render error
    # respond_with(@collection)
    
  end

  

  def get_suppliers
    @suppliers = Spree::Supplier.order(:name)
  end

  # Scopes the collection to the Supplier.
  def supplier_collection
    if try_spree_current_user && !try_spree_current_user.admin? && try_spree_current_user.supplier?
      @collection = @collection.joins(:suppliers).where('spree_suppliers.id = ?', try_spree_current_user.supplier_id)
    end
  end

  # Newly added products by a Supplier are associated with it.
  def add_product_to_supplier
    if try_spree_current_user && try_spree_current_user.supplier?
      @product.add_supplier!(try_spree_current_user.supplier_id)
    end
  end

end