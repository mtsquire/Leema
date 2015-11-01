require 'autoscaler/sidekiq'
require 'autoscaler/heroku_platform_scaler'

Sidekiq.configure_client do |config|
  config.client_middleware do |chain|
    p 'im doing stuff!'
    chain.add Autoscaler::Sidekiq::Client, 'default' => Autoscaler::HerokuPlatformScaler.new
  end
end

Sidekiq.configure_server do |config|
  config.server_middleware do |chain|
    p 'im doin stuff again!'
    chain.add(Autoscaler::Sidekiq::Server, Autoscaler::HerokuPlatformScaler.new, 60) # 60 second timeout
  end
end