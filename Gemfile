ruby "3.1.2"

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails"

gem "bcrypt"
gem "bootsnap", require: false
gem "importmap-rails"
gem "pg"
gem "puma"
gem "redis"
gem "sprockets-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"

group :development, :test do
  gem "byebug"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "standardrb"
end

group :test do
  gem "capybara"
  gem "capybara-screenshot"
  gem "ffaker"
  gem "launchy"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :development do
  gem "dockerfile-rails"
  gem "lefthook"
  gem "listen"
  gem "web-console"
end
