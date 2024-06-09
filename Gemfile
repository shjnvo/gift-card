# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.1.0'

gem 'annotate'
gem 'rails', '~> 7.1.3', '>= 7.1.3.4'

gem 'pg', '~> 1.1'

gem 'puma', '>= 5.0'

gem 'bcrypt', '~> 3.1.7'

gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[mswin mswin64 mingw x64_mingw jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri mswin mswin64 mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails', require: false
end

group :development do
  gem 'error_highlight', '>= 0.4.0', platforms: [:ruby]
  gem 'rack-mini-profiler'
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
end
