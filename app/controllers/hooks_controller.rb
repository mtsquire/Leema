class HooksController < ApplicationController
# to bypass CSRF token authenticity error
skip_before_filter  :verify_authenticity_token

  def stripe
    case params[:type]
      when 'balance.available'
        @charges = Stripe::Charge.all
        #Transfer money to supplier bank account after balance is available.
        puts "Initiating Stripe transfer"
        transfer = Stripe::Transfer.create(
          :amount => 10000, # amount in cents
          :currency => "usd",
          :recipient => recipient_id,
          :bank_account => bank_account_id,
          :statement_descriptor => "JULY SALES"
)
      end
  end
end
