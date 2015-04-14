Spree::Admin::ShipmentsController.class_eval do
  require 'json'

  skip_before_action :verify_authenticity_token

  def index
    params[:q] ||= {}
    # params[:q][:completed_at_null] ||= '1'
    # @show_only_incomplete = params[:q][:completed_at_null].present?
    # params[:q][:s] ||= @show_only_incomplete ? 'created_at desc' : 'completed_at desc'

    # As date params are deleted if @show_only_incomplete, store
    # the original date so we can restore them into the params
    # after the search
    created_at_gt = params[:q][:created_at_gt]
    created_at_lt = params[:q][:created_at_lt]

    if !params[:q][:created_at_gt].blank?
      params[:q][:created_at_gt] = Time.zone.parse(params[:q][:created_at_gt]).beginning_of_day rescue ""
    end

    if !params[:q][:created_at_lt].blank?
      params[:q][:created_at_lt] = Time.zone.parse(params[:q][:created_at_lt]).end_of_day rescue ""
    end
    #Scoping shipments to the suppliers unless you're a badass leema admin
    if spree_current_user.leema_admin? == true
      @search = Spree::Shipment.where("stock_location_id = ? and state = ?", spree_current_user.supplier.stock_locations.first.id, "ready" or "shipped").ransack(params[:q])
    else
      @search = Spree::Shipment.accessible_by(current_ability, :index).ransack(params[:q])
    end
    @shipments = @search.result.
      page(params[:page]).
      per(params[:per_page] || Spree::Config[:orders_per_page])

    # Restore dates
    params[:q][:created_at_gt] = created_at_gt
    params[:q][:created_at_lt] = created_at_lt
  end

end