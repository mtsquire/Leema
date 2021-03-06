class Spree::SuppliersController < Spree::StoreController

  before_filter :check_if_supplier, only: [:create, :new]
  before_filter :check_if_leema_admin, except: [:create, :new]
  ssl_required

  def create
    authorize! :create, Spree::Supplier

    @supplier = Spree::Supplier.new(supplier_params)

    # Dont sign in as the newly created user if users already signed in.
    unless spree_current_user
      # Find or create user for email.
      if @user = Spree.user_class.find_by_email(params[:supplier][:email])
        unless @user.valid_password?(params[:supplier][:password])
          flash[:error] = Spree.t('supplier_registration.create.invalid_password')
          render :new and return
        end
      else
        @user = Spree.user_class.new(email: params[:supplier][:email], password: params[:supplier].delete(:password), password_confirmation: params[:supplier].delete(:password_confirmation))
        @user.save!
        session[:spree_user_signup] = true
      end
      sign_in(Spree.user_class.to_s.underscore.gsub('/', '_').to_sym, @user)
      associate_user
    end

    # Now create supplier.

    @supplier.email = spree_current_user.email if spree_current_user

    if @supplier.save
      flash[:success] = Spree.t('supplier_registration.create.success')
      redirect_to spree.account_path
    else
      render :new
    end
  end

  def new
    authorize! :create, Spree::Supplier
    @supplier = Spree::Supplier.new
    @supplier.address = Spree::Address.default
  end

  private

  def check_if_supplier
    if spree_current_user and spree_current_user.supplier?
      flash[:error] = Spree.t('supplier_registration.already_signed_up')
      redirect_to spree.account_path and return
    end
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

  def supplier_params
    params.require(:supplier).permit(:first_name, :name, :last_name, :tax_id, :store_name, :cover_photo, :store_logo, :allow_pickup)
  end

end
