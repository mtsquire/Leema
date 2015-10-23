Spree::Admin::PromotionsController.class_eval do
  before_filter :check_if_leema_admin

  protected
  def collection
    return @collection if defined?(@collection)
    params[:q] ||= HashWithIndifferentAccess.new
    params[:q][:s] ||= 'id desc'

    @collection = super
    @search = @collection.ransack(params[:q])
    @collection = @search.result(distinct: true).
      includes(promotion_includes).
      page(params[:page])

    @collection
  end

  # only allow leema admins to view this page
  def check_if_leema_admin
    if !spree_current_user.leema_admin?
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
    end
  end

end