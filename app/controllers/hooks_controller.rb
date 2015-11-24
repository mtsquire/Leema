class HooksController < ApplicationController
# to bypass CSRF token authenticity error
skip_before_filter  :verify_authenticity_token

  def stripe
    #using easypost now as the webhook event
    # case params[:description]
    # From EasyPost API https://www.easypost.com/docs/api#webhooks: 
    # tracker.updated: Fired when the status for the scan form changes
    # when 'tracker.updated'
    #   @shipments = Spree::Shipment.where(transferred: false, state: "shipped")
    #   @shipments.each do |shipment|
    #     item_total = 0
    #     shipment.line_items.each do |item|
    #       item_total += item.product.price * item.quantity
    #     end  
    #     transfer = Stripe::Transfer.create(
    #       # Take 10% for ourselves from the total cost
    #       # of items per supplier(shipment)
    #       :amount => (item_total * (100 - shipment.supplier.commission_percentage)).floor,
    #       :currency => "usd",
    #       :recipient => shipment.supplier.token
    #     )
    #     shipment.transferred = true
    #     shipment.save!
    #   end
    # end
    case params[:result][:status]
    when 'in_transit'
      @shipment = Spree::Shipment.where(
        transferred: false,
        state: "shipped",
        easypost_id: params[:result][:shipment_id]
        ).first
      item_total = 0
      if !@shipment
        puts 'no shipment found'
        return
      end
      @shipment.line_items.each do |item|
        item_total += item.product.price * item.quantity
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
