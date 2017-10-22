source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.1'

gem 'rails', '~> 5.1.4'
gem 'pg',    '~> 0.18'
gem 'puma',  '~> 3.7'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'

gem 'devise_token_auth', '~> 0.1.42'
gem 'cancancan',         '~> 2.0'

gem 'rack-cors'

group :development, :test do
  gem 'ruby-debug-ide'
  gem 'debase'
end

group :development do
  gem 'spring'
  gem 'figaro'
end

group :test do
  gem 'rspec-rails',        '~> 3.7'
  gem 'factory_girl_rails', '~> 4.8'
  gem 'json_matchers',      '~> 0.7.2'
  gem 'shoulda-matchers',   '~> 3.1',  '>= 3.1.2'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
