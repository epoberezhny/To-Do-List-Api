require_relative 'boot'

require 'rails'

require 'active_record/railtie'
require 'action_controller/railtie'

Bundler.require(*Rails.groups)

module ToDoListApi
  class Application < Rails::Application
    config.load_defaults 5.1

    config.api_only = true

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end
end
