source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.3.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# authentication and authorisation
gem 'devise'
gem 'pundit'
gem 'omniauth', '~> 1.9.1'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'

group :development do
  # Dev email testing
  gem 'letter_opener'
  # Anotate models
  gem 'annotate'
end

# For client side validations
gem 'client_side_validations'

# AWS sdk
gem 'aws-sdk-elastictranscoder'
gem 'aws-sdk-sns'

# AWS s3 storage
gem 'aws-sdk-cloudfront'
gem 'aws-sdk-s3', require: false
gem 'image_processing', '~> 1.8'
gem 'marcel', '~> 0.3'
gem 'mini_magick' # image processing
gem 'shrine', '~> 3.0'

# nested forms
gem 'cocoon'

# MUX integration
gem 'mux_ruby', '~> 1.7.0'

# Sidekiq background processing
gem 'sidekiq'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# gem
gem "honeybadger", "~> 4.0"

# Stripe payment
gem 'stripe'

# Maintain environment variables
gem 'dotenv-rails', groups: %i[development test]

# Service objects and business logic abstraction
gem 'interactor'

# locally time with
gem 'local_time'

# Soft deletion done right
gem 'discard', '~> 1.2'

# Schedule tasks
gem 'whenever', require: false
