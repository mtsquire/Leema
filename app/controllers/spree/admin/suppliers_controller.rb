class Spree::Admin::SuppliersController < Spree::Admin::ResourceController
  before_filter :check_if_leema_admin

  def index
    unless spree_current_user.leema_admin?
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
    end
  end

  def edit
    @object.address = Spree::Address.default unless @object.address.present?
    respond_with(@object) do |format|
      format.html { render :layout => !request.xhr? }
      format.js   { render :layout => false }
    end
  end

  def new
    @object = Spree::Supplier.new(address_attributes: {country_id: Spree::Address.default.country_id})
  end

  private

    def collection
      params[:q] ||= {}
      params[:q][:meta_sort] ||= "name.asc"
      @search = Spree::Supplier.search(params[:q])
      @collection = @search.result.page(params[:page]).per(Spree::Config[:orders_per_page])
    end

    def find_resource
      Spree::Supplier.friendly.find(params[:id])
    end

    def location_after_save
      spree.edit_admin_supplier_path(@object)
    end

    def check_if_leema_admin
      if !spree_current_user.leema_admin?
        # the url can be accessed by either the id or the slug of the supplier so
        # if either of these match we authenticate the user
        if (spree_current_user.supplier.id.to_s != params[:id]) && (spree_current_user.supplier.slug != params[:id])
          respond_to do |format|
            format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
            format.xml  { head :not_found }
            format.any  { head :not_found }
          end
        end
      end
    end

end
