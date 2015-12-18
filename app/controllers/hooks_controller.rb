class HooksController < ApplicationController
# to bypass CSRF token authenticity error
skip_before_filter  :verify_authenticity_token

  def stripe
    case params[:result][:status]
      when 'in_transit'
        @shipment = Spree::Shipment.where(
          transferred: false,
          state: "shipped",
          tracking: params[:result][:tracking_code]
          ).first
        if !@shipment
          puts 'no shipment found'
          return
        end
        item_total = 0
        @shipment.line_items.each do |item|
          item_total += item.variant.price * item.quantity
        end
        transfer = Stripe::Transfer.create(
          # Take 10% for ourselves from the total cost
          # of items per supplier(shipment)
          :amount => (item_total * (100 - @shipment.supplier.commission_percentage)).floor,
          :currency => "usd",
          :recipient => @shipment.supplier.token
        )
        @shipment.transferred = true
        @shipment.save!
      when 'delivered'
        @delivered_shipment = Spree::Shipment.find_by_tracking(params[:result][:tracking_code])
        Spree::ShipmentMailer.order_delivered_email(@delivered_shipment.id).deliver!
    end
  end
end
