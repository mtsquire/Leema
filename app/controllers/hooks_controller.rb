class HooksController < ApplicationController
# to bypass CSRF token authenticity error
skip_before_filter  :verify_authenticity_token

  def stripe
    @shipments = Spree::Shipment.all
    case params[:type]
      when 'balance.available'
        @charge = Stripe::Charge.all
        @shipments.each do |shipment|
          puts "Initiating Stripe transfer"
          item_total = 0
          shipment.line_items.each do |item|
            item_total += item.product.price
          end  
          transfer = Stripe::Transfer.create(
            # Take 10% for ourselves from the total cost
            # of items per supplier(shipment)
            # shipment.final_price is shipping cost plus tax
            :amount => ((item_total * 90) + (shipment.cost * 100)).floor,
            :currency => "usd",
            :recipient => shipment.supplier.token
          )
          shipment.stripe_charge_id = 
        end
      end
  end
end
