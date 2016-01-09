Spree::Stock::Estimator.class_eval do
  def shipping_rates(package)
    order = package.order
    from_address = process_address(package.stock_location)
    to_address = process_address(order.ship_address)
    parcel = build_parcel(package)
    shipment = build_shipment(from_address, to_address, parcel)
    rates = shipment.rates.sort_by { |r| r.rate.to_i }
    delivery_area = package.stock_location.supplier.delivery_area

    if rates.any?
      rates.each do |rate|
        package.shipping_rates << Spree::ShippingRate.new(
          :name => "#{rate.carrier} #{rate.service}",
          :cost => (rate.rate.to_f + 0.35).to_s, #add in 35 cent processing fee
          :easy_post_shipment_id => rate.shipment_id,
          :easy_post_rate_id => rate.id,
          :easy_post_delivery_days => rate.delivery_days
        )
      end

      byebug

      if order.ship_address.geocoded? && delivery_area
        # strip out () from the coords data and turn it into a comma separated array
        # ex: ["41, 70.3, 40, 70, 41, 83, 41, 82"]
        coordsArray = delivery_area.tr('() ', '').split(',')

        # store our coords here after we convert them to floats
        floatCoords = []
        coordsArray.each do |coord|
          # convert the coordinate strings to floats
          floatCoords << coord.to_f
        end

        # splits the floatCoords array into lat/lng paired subarrays
        finalCoords = []
        floatCoords.each_slice(2) do |lat, lng|
          finalCoords << [lat, lng]
        end

        # construct the delivery area polygon
        polygonArray = []
        finalCoords.each do |pairs|
          polygonArray << Geokit::LatLng.new(pairs[0],pairs[1])
        end
        polygon = Geokit::Polygon.new(polygonArray)
        delivery_location = Geokit::LatLng.new(order.ship_address.latitude, order.ship_address.longitude)
        byebug
        if polygon.contains?(delivery_location)
          byebug
          package.shipping_rates << Spree::ShippingRate.new(
            :name => "Delivery",
            :cost => (package.stock_location.supplier.delivery_fee.to_f)
            )
        end
      end

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
      ep_address_attrs[:company] = address.supplier.store_name
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
    total_weight = package.contents.sum do |item|
      weight = item.variant.shipping_category.name.to_i
      # if shipping category selected was lbs we convert to oz for easypost
      if item.variant.shipping_category.name.include?('lb')
        item.quantity * (weight * 16)
      else
        item.quantity * (weight)
      end
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