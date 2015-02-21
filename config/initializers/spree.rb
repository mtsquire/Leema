# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false
  if Rails.env.production?
    attachment_config = {
        s3_credentials: {
          access_key_id: ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
          bucket: ENV['S3_BUCKET_NAME'],
        },

        storage:        :s3,
        s3_headers:     { "Cache-Control" => "max-age=31557600" },
        s3_protocol:    "https",
        bucket:         ENV['S3_BUCKET_NAME'],

        styles: {
          mini:     "48",
          small:    "100",
          product:  "240",
          large:    "720"
        },

        path:          ":rails_root/public/spree/products/:id/:style/:basename.:extension",
        default_url:   "/spree/products/:id/:style/:basename.:extension",
        default_style: "product",
      }

    attachment_config.each do |key, value|
      Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
    end
  end
end unless Rails.env.test?

Spree.user_class = "User"

          Rails.application.config.to_prepare do
            require_dependency 'spree/authentication_helpers'
          end
