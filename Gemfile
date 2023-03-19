source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.0"

## Core
gem "rails", "~> 7.0.4", ">= 7.0.4.3"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "tzinfo-data"
gem 'nokogiri', '~> 1.14', '>= 1.14.2'
gem 'sprockets-rails'
gem "bootsnap", require: false

## API
gem 'grape'
gem 'grape-swagger'
gem 'grape-swagger-rails'
gem 'grape-jsonapi', require: "grape_jsonapi"
gem 'jsonapi-serializer'
gem 'kaminari'
gem 'rack-cors'

## Support
gem 'activerecord_json_validator'

group :development, :test do
  gem 'rubocop', require: false
end

group :test do
  gem 'rspec-rails', '~> 6.0.1'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
end
