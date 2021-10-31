ruby "3.0.2"

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails"

gem "bcrypt"
gem "bootsnap", require: false
gem "pg"
gem "puma"
gem "turbolinks"
gem "webpacker"

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
  gem "shoulda-matchers"
  gem "webdrivers"
end

group :development do
  gem "listen"
  gem "spring"
  gem "web-console"
end
