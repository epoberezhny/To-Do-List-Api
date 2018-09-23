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

group :development, :test do
  gem 'spring'
  gem 'figaro'
end

group :test do
  gem 'rspec-rails',           '~> 3.7'
  gem 'factory_girl_rails',    '~> 4.8'
  gem 'json_matchers',         '~> 0.7.2'
  gem 'spring-commands-rspec', '~> 1.0',  '>= 1.0.4'
  gem 'shoulda-matchers',      '~> 3.1',  '>= 3.1.2'
  gem 'rspec_junit_formatter'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
