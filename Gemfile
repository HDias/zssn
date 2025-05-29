source "https://rubygems.org"

gem "rails", "~> 8.0.2"

gem "bootsnap", require: false
gem "kamal", require: false
gem "pg"
gem "puma", ">= 5.0"
gem "rack-cors"
gem "thruster", require: false
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "rswag-api"
gem "rswag-ui"

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "factory_bot_rails"
  gem "ffaker"
  gem "rspec-rails", "~> 7.0.0"
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "shoulda-matchers", "~> 6.0"
end
