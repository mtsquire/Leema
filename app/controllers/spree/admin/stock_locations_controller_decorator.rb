Spree::Admin::StockLocationsController.class_eval do
  include ApplicationHelper
  before_filter :check_if_leema_admin
  create.after :set_supplier

  private

  def set_supplier
    if try_spree_current_user.supplier?
      @object.supplier = try_spree_current_user.supplier
      @object.save
    end
  end

end