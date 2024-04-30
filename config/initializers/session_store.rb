# frozen_string_literal: true

# For devise token auth
Rails.application.config.tap do |config|
  config.session_store :cache_store
  config.middleware.use config.session_store, config.session_options
end
