class HooksController < ApplicationController
  def stripe
    case params[:type]
      when 'balance.available'
        #Transfer money to supplier bank account after balance is available.
        puts "Initiating Stripe transfer"
        transfer = Stripe::Transfer.create(
          #Take 10% for ourselves
          :amount => (product.price * 90).floor,
          :currency => "usd",
          :recipient => product.suppliers.first.token
        )
      end
  end
end
