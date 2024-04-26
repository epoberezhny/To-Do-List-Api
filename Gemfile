source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.1'

gem 'rails', '~> 5.1.4'
gem 'pg'
gem 'puma'
gem 'oj'

gem 'devise_token_auth'
gem 'cancancan'

gem 'rack-cors'

gem 'carrierwave'
gem 'cloudinary'

gem 'acts_as_list'

gem 'newrelic_rpm'
gem 'rollbar'
gem "sentry-raven"

group :development, :test do
  gem 'spring', '~> 2.0'
  gem 'figaro'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails', '~> 6.2.0'
  gem 'json_matchers'
  gem 'spring-commands-rspec'
  gem 'shoulda-matchers'
  gem 'rspec_junit_formatter'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
