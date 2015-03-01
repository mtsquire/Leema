class HooksController < ApplicationController
# to bypass CSRF token authenticity error
skip_before_filter  :verify_authenticity_token

  def stripe
    case params[:type]
      when 'balance.available'
        #Transfer money to supplier bank account after balance is available.
        puts "Initiating Stripe transfer"
        puts "Hey this webhook worked"
      end
  end
end
