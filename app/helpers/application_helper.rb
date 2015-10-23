module ApplicationHelper

  # only allow leema admins to view a page
  def check_if_leema_admin
    if !spree_current_user.leema_admin?
      respond_to do |format|
        format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
        format.xml  { head :not_found }
        format.any  { head :not_found }
      end
    end
  end

  # only allow leema admins or the specific seller access to view a page
  def check_if_leema_admin_or_seller
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

  def check_if_leema_admin_or_bank_account_owner
    if !spree_current_user.leema_admin?
      if (params[:_method] != 'delete' && spree_current_user.supplier.slug != params[:supplier_id])
        respond_to do |format|
          format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
          format.xml  { head :not_found }
          format.any  { head :not_found }
        end
      else
        # this block means that the user is trying to delete their bank account
        if (spree_current_user.supplier.id.to_s != params[:supplier_id])
          respond_to do |format|
            format.html { render :file => "#{Rails.root}/public/404", :layout => false, :status => :not_found }
            format.xml  { head :not_found }
            format.any  { head :not_found }
          end
        end
      end
    end
  end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def image(og_image)
    content_for(:image) { og_image }
  end

  def ogtype(og_type)
    content_for(:ogtype) { og_type }
  end

  def link_to_cart(text = nil)
    return "" if current_spree_page?(spree.cart_path)

    text = text ? h(text) : Spree.t('cart')
    css_class = nil

    if current_order.nil? or current_order.item_count.zero?
      text = "<i class='fa fa-shopping-cart'></i> <span class='item-count'>(#{Spree.t('0')})</span>".html_safe
      css_class = 'empty'
    else
      text = "<i class='fa fa-shopping-cart'></i> <span class='item-count'>(#{current_order.item_count})</span>".html_safe
      css_class = 'full'
    end

    link_to text, spree.cart_path, :class => "cart-info #{css_class}"
  end

  def current_spree_page?(url)
    path = request.fullpath.gsub(/^\/\//, '/')
    if url.is_a?(String)
      return path == url
    elsif url.is_a?(Hash)
      return path == spree.url_for(url)
    end
    return false
  end

  def current_order(options = {})
    options[:create_order_if_necessary] ||= false
    options[:lock] ||= false
    return @current_order if @current_order
    @current_order = find_order_by_token_or_user(options)

    if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
      @current_order = Spree::Order.new(current_order_params)
      @current_order.user ||= current_user
      # See issue #3346 for reasons why this line is here
      @current_order.created_by ||= current_user
      @current_order.save!
    end

    if @current_order
      return @current_order
    end
  end

  def current_order(options = {})
    options[:create_order_if_necessary] ||= false
    options[:lock] ||= false
    return @current_order if @current_order
    @current_order = find_order_by_token_or_user(options)

    if options[:create_order_if_necessary] && (@current_order.nil? || @current_order.completed?)
      @current_order = Spree::Order.new(current_order_params)
      @current_order.user ||= current_user
      # See issue #3346 for reasons why this line is here
      @current_order.created_by ||= current_user
      @current_order.save!
    end

    if @current_order
      return @current_order
    end
  end

  def find_order_by_token_or_user(options={})

    # Find any incomplete orders for the guest_token
    order = Spree::Order.incomplete.includes(:adjustments).lock(options[:lock]).find_by(current_order_params)
    # Find any incomplete orders for the current user
    if order.nil? && current_user
      order = Spree::Order.incomplete.order('id DESC').where({ currency: current_currency, user_id: current_user.try(:id)}).first
      # If there is no prior order, find the latest in progress
      # order from the guest and associate it with the newly logged in user
      if !order
        order = Spree::Order.incomplete.find_by({ currency: current_currency, guest_token: cookies.signed[:guest_token], user_id: nil })
      end
    end

    order
  end

  def find_order_by_token_or_user(options={})

    # Find any incomplete orders for the guest_token
    order = Spree::Order.incomplete.includes(:adjustments).lock(options[:lock]).find_by(current_order_params)
    # Find any incomplete orders for the current user
    if order.nil? && current_user
      order = Spree::Order.incomplete.order('id DESC').where({ currency: current_currency, user_id: current_user.try(:id)}).first
      # If there is no prior order, find the latest in progress
      # order from the guest and associate it with the newly logged in user
      if !order
        order = Spree::Order.incomplete.find_by({ currency: current_currency, guest_token: cookies.signed[:guest_token], user_id: nil })
      end
    end

    order
  end

  def current_order_params
    { currency: current_currency, guest_token: cookies.signed[:guest_token], user_id: current_user.try(:id) }
  end

  def current_currency
    Spree::Config[:currency]
  end

  # stuff to put devise logic on other controller pages

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
  
end
