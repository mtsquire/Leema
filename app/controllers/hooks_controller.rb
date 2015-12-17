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
        # if shipping was included in cost then transfer from the
        # cost_price field
        if item.product.shipping_included == 1
          item total += item.product.cost_price * item.quantity
        else
          item_total += item.product.price * item.quantity
        end
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
    end
  end
end
