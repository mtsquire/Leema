if Rails.env.development?
  Rack::Timeout.timeout = 99999999999999999999999999  # seconds
else
  Rack::Timeout.timeout = 20
end