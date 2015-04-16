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
  # Adding create method here to override the resource controller method
  def create
    print "creating product..."
    @object.attributes = permitted_resource_params
    if @object.save
      flash[:success] = flash_message_for(@object, :successfully_created)
      respond_with(@object) do |format|
        format.html { redirect_to stock_admin_product_path(@object) }
        format.js   { render :layout => false }
      end
    else
      invoke_callbacks(:create, :fails)
      respond_with(@object) do |format|
        format.html do
          flash.now[:error] = @object.errors.full_messages.join(", ")
          render action: 'new'
        end
        format.js { render layout: false }
      end
    end
  end

  # Set this up for the search functionality
  def index
    @user = spree_current_user
    @supplier = @user.supplier
    if @user.leema_admin? == true
      @collection = Spree::Product.all
    else
      @collection = @user.supplier.products.all
    end
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

  #added this to fix the unknown method "per" problem deriving from this method in spree backend
  private 
  def collection
          return @collection if @collection.present?
          params[:q] ||= {}
          params[:q][:deleted_at_null] ||= "1"

          params[:q][:s] ||= "name asc"
          @collection = super
          @collection = @collection.with_deleted if params[:q].delete(:deleted_at_null) == '0'
          # @search needs to be defined as this is passed to search_form_for
          @search = @collection.ransack(params[:q])
          @collection = @search.result.
                distinct_by_product_ids(params[:q][:s]).
                includes(product_includes).
                page(params[:page])

          @collection
        end

end