Spree::Admin::BaseController.class_eval do
  before_filter :restrict_access

  def restrict_access
    if !spree_current_user.leema_admin?
      allowed_access = [
        'shipments',
        'suppliers',
        'products',
        'supplier_bank_accounts',
        'images',
        'prototypes']
        # need prototypes otherwise products wont populate a variant id and custom orders wont work
        # this is hacky because we dont want suppliers being able to tamper with the
        # store/admin/prototypes page and we should find a way to make this more secure
      unless allowed_access.include?(controller_name)
        respond_to do |format|
          format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
          format.xml  { head :not_found }
          format.any  { head :not_found }
        end
      end
    end
  end

end