class HooksController < ApplicationController
  def stripe
    case params[:type]
      when 'balance.available'
        #Transfer money to supplier bank account after balance is available.
        puts "Initiating Stripe transfer"
        puts "Hey this webhook worked"
      end
  end
end
