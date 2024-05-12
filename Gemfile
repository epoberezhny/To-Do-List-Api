# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '3.3.1'

gem 'bootsnap', require: false
gem 'pg'
gem 'puma'
gem 'rails', '~> 7.1.0'

# authentication & authorization
gem 'cancancan'
gem 'jwt'
gem 'rodauth-rails'

gem 'rack-cors'

# serialization
gem 'jserializer'
gem 'oj'

# gem 'image_processing'
gem 'shrine'
gem 'shrine-cloudinary'

gem 'acts_as_list'

# monitoring
gem 'newrelic_rpm'
gem 'rollbar'

group :development, :test do
  gem 'listen', require: false
  gem 'spring', require: false

  # debugging
  gem 'pry-byebug'

  # api docs
  gem 'rswag-api'
  gem 'rswag-specs'
  gem 'rswag-ui'

  # rubocop
  gem 'rubocop', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'rubocop-rspec_rails', require: false
end

group :test do
  gem 'factory_bot_rails'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spring-commands-rspec'
  gem 'timecop'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
