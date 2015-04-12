class HooksController < ApplicationController
# to bypass CSRF token authenticity error
skip_before_filter  :verify_authenticity_token

  def stripe
    case params[:type]
      when 'balance.available'
        # only reference shipments that havent been transferred and are shipped
        @shipments = Spree::Shipment.where("transferred = ? and state = ?", false, "ready") 
        @shipments.each do |shipment|
          item_total = 0
          shipment.line_items.each do |item|
            item_total += item.product.price * item.quantity
          end  
          transfer = Stripe::Transfer.create(
            # Take 10% for ourselves from the total cost
            # of items per supplier(shipment)
            :amount => (item_total * 90).floor,
            :currency => "usd",
            :recipient => shipment.supplier.token
          )
          shipment.transferred = true 
          shipment.save!
        end
      end
  end
end
