if Rails.env.development?
  require 'httparty'
  require 'json'

  class PostmatesController < ApplicationController
    @client_token = Braintree::ClientToken.generate

    def get_delivery
      api_key = 'f948ddc7-01e3-428d-8d4f-2155ab8f4e14'
      dropoff = "312 W 48th Street, New York, NY 10128"
      pickup = "619 W 54th St, New York, NY 10019"
      @customer = 'cus_K8mRn4ovuNyNKV'
      @urlstring_to_post = 'https://api.postmates.com/v1/customers/' + @customer + '/delivery_quotes'

      @result = HTTParty.post(@urlstring_to_post.to_str,
        :body => { :dropoff_address => "312 W 48th Street, New York, NY 10128", 
                   :pickup_address => "619 W 54th St, New York, NY 10019" },
        :basic_auth => { :username => api_key })
    end

  end
end