DeviseTokenAuth.setup do |config|
  config.token_lifespan = 1.weeks

  config.max_number_of_devices = 5

  config.batch_request_buffer_throttle = 10.seconds
end
