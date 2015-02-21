module ApplicationHelper
  
  def link_to_cart(text = nil)
    return "" if current_spree_page?(spree.cart_path)

    text = text ? h(text) : Spree.t('cart')
    css_class = nil

    if current_order.nil? or current_order.item_count.zero?
      text = "<i class='fa fa-shopping-cart'></i> <span class='item-count'>(#{Spree.t('empty')})</span>".html_safe
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

  def find_order_by_token_or_user(options={})

    # Find any incomplete orders for the guest_token
    order = Spree::Order.incomplete.includes(:adjustments).lock(options[:lock]).find_by(current_order_params)

    # Find any incomplete orders for the current user
    if order.nil? && current_user
      order = Spree::Order.incomplete.order('id DESC').where({ currency: current_currency, user_id: current_user.try(:id)}).first
    end

    order
  end

  def current_order_params
    { currency: current_currency, guest_token: cookies.signed[:guest_token], user_id: current_user.try(:id) }
  end

  def current_currency
    Spree::Config[:currency]
  end
end
