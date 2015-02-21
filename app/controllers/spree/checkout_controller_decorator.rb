Spree::CheckoutController.class_eval do
  require 'httparty'
  require 'json'

  def get_delivery
    api_key = 'f948ddc7-01e3-428d-8d4f-2155ab8f4e14'
    dropoff = @order.ship_address
    pickup = @order.ship_address
    @customer = 'cus_K8mRn4ovuNyNKV'
    @urlstring_to_post = 'https://api.postmates.com/v1/customers/' + @customer + '/delivery_quotes'

    @result = HTTParty.post(@urlstring_to_post.to_str,
      :body => { :dropoff_address => dropoff, 
                 :pickup_address => "205 East 95th Street, New York, NY 10128" },
      :basic_auth => { :username => api_key })
  end

end