source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.1'

gem 'rails', '~> 5.1.4'
gem 'pg',    '~> 0.18'
gem 'puma',  '~> 3.7'
gem 'oj'

gem 'devise_token_auth', '~> 0.1.42'
gem 'cancancan',         '~> 2.0'

gem 'rack-cors'

gem 'carrierwave', '~> 1.2', '>= 1.2.1'
gem 'cloudinary',  '~> 1.8', '>= 1.8.1'

gem 'acts_as_list', '~> 0.9.9'

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
