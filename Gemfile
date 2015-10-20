source 'https://rubygems.org'
gem 'devise', '3.2.4'
gem 'rails', '4.1.6'

# Use puma as the production webserver
gem 'puma', group: :production
# Heroku kills processes that take longer than 30 seconds, this gem tells puma to kill them too
gem "rack-timeout"
# Use postgres as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# testing
group :development, :test do
  gem 'rspec-rails', '~> 3.0'
end

gem 'capybara'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Facebook authentication
gem 'omniauth'
gem 'omniauth-facebook'

# Used as currency fields
gem 'money-rails'
gem 'cancancan', '~> 1.9'

# executing async tasks in the background
gem 'sidekiq'

group :development do
  # speed up the local web server
  gem 'rails-dev-boost', :git => 'git://github.com/thedarkone/rails-dev-boost.git'
  gem 'rb-fsevent', '>= 0.9.1'
  # debugging
  gem 'xray-rails'
  gem 'byebug'
end

# New Relic for server monitoring
gem 'newrelic_rpm'

gem "therubyracer"
gem "less-rails" #Sprockets (what Rails 3.1 uses for its asset pipeline) supports LESS
gem "twitter-bootstrap-rails"
gem 'spree', '2.3.4'
gem 'spree_gateway', :git => 'https://github.com/spree/spree_gateway.git', :branch => '2-3-stable'
gem 'spree_reviews', github: 'spree-contrib/spree_reviews', branch: '2-3-stable'
gem 'aws-sdk' #For using S3 to store images
gem "fog"
gem "asset_sync" #sync assets to s3

#multi-tenancy
gem 'spree_drop_ship', github: 'jdutil/spree_drop_ship', branch: '2-3-stable'
gem 'spree_marketplace', github: 'jdutil/spree_marketplace'
gem 'spree_mail_settings', github: 'spree-contrib/spree_mail_settings', branch: '2-3-stable'
gem 'easypost'

#For Heroku deployment
gem 'rails_12factor', group: :production
ruby "2.1.2"



