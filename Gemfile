# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '3.3.1'

gem 'bootsnap', require: false
gem 'oj'
gem 'pg'
gem 'puma'
gem 'rails', '~> 7.1.0'

gem 'cancancan'
gem 'jwt'
gem 'rodauth-rails'

gem 'rack-cors'

gem 'carrierwave'
gem 'cloudinary'

gem 'acts_as_list'

gem 'newrelic_rpm'
gem 'rollbar'

group :development, :test do
  gem 'figaro'
  gem 'listen', require: false
  gem 'pry-byebug'
  gem 'rubocop'
  gem 'rubocop-factory_bot'
  gem 'rubocop-rails'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
  gem 'spring'
end

group :test do
  gem 'factory_bot_rails'
  gem 'json_matchers'
  gem 'rspec_junit_formatter'
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'spring-commands-rspec'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
