Devise.setup do |config|
  require 'devise/orm/active_record'

  config.navigational_formats = [:json]
end
