class Spree::Admin::SuppliersController < Spree::Admin::ResourceController
  include ApplicationHelper
  before_filter :check_if_leema_admin_or_seller, except: [:create, :new]

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

  def update
    # new logic for saving delivery data to supplier object
    if params[:supplier][:delivery_fee]
      update_delivery and return
    end
    # Do all the regular update code for editing other supplier info
    super
  end

  def update_delivery
    @object.delivery_fee = params[:supplier][:delivery_fee]
    @raw_delivery_area = params[:supplier][:delivery_area]
    @object.delivery_area = @raw_delivery_area.tr('() ', '')
    if @object.update_attributes(delivery_params)
      flash[:success] = flash_message_for(@object, :successfully_updated)
      respond_with(@object) do |format|
        format.html { redirect_to location_after_delivery_save }
        format.js   { render :layout => false }
      end
    else
      respond_with(@object) do |format|
        format.html do
          flash.now[:error] = @object.errors.full_messages.join(", ")
          render action: 'edit'
        end
        format.js { render layout: false }
      end
    end
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

    def location_after_delivery_save
      delivery_path(@object.id)
    end

    def delivery_params
      params.require(:supplier).permit(:delivery_fee, :delivery_area)
    end

end
