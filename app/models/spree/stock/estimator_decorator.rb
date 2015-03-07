Spree::Stock::Estimator.class_eval do
  def shipping_rates(package)
    order = package.order

    from_address = process_address(package.stock_location)
    to_address = process_address(order.ship_address)
    parcel = build_parcel(package)
    shipment = build_shipment(from_address, to_address, parcel)
    rates = shipment.rates.sort_by { |r| r.rate.to_i }

    if rates.any?
      rates.each do |rate|
        package.shipping_rates << Spree::ShippingRate.new(
          :name => "#{rate.carrier} #{rate.service}",
          :cost => rate.rate,
          :easy_post_shipment_id => rate.shipment_id,
          :easy_post_rate_id => rate.id
        )
      end

      # Sets cheapest rate to be selected by default
      package.shipping_rates.first.selected = true

      package.shipping_rates
    else
      []
    end
  end

  private

  def process_address(address)
    ep_address_attrs = {}
    # Stock locations do not have "company" attributes,
    ep_address_attrs[:company] = if address.respond_to?(:company)
      address.company
    else
      "Leema, LLC"
    end
    ep_address_attrs[:name] = address.full_name if address.respond_to?(:full_name)
    ep_address_attrs[:street1] = address.address1
    ep_address_attrs[:street2] = address.address2
    ep_address_attrs[:city] = address.city
    ep_address_attrs[:state] = address.state ? address.state.abbr : address.state_name
    ep_address_attrs[:zip] = address.zipcode
    ep_address_attrs[:phone] = address.phone

    ::EasyPost::Address.create(ep_address_attrs)
  end

  def build_parcel(package)
    package_weight = 0
    order.products.each do |product|
      package_weight += product.shipping_category.name.to_i
    end

    puts "#{package_weight}"  

    total_weight = package.contents.sum do |item|
      # item = Spree::Stock::Package::ContentItem
      item.quantity * item.variant.weight + package_weight
    end

    parcel = ::EasyPost::Parcel.create(
      :weight => total_weight
    )
  end

  def build_shipment(from_address, to_address, parcel)
    shipment = ::EasyPost::Shipment.create(
      :to_address => to_address,
      :from_address => from_address,
      :parcel => parcel
    )
  end

end