# frozen_string_literal: true

require_relative 'helpers/auth'

RSpec.configure do |config|
  config.include Auth, type: :request
  config.include Auth, type: :controller
end
