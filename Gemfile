ruby "4.0.9"

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails"

gem "bootsnap", require: false
gem "commonmarker", ">= 2.10"
gem "importmap-rails"
gem "oga"
gem "puma"
gem "resend"
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"
gem "sprockets-rails"
gem "sqlite3"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "view_component"

group :development, :test do
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "standardrb"
end

group :test do
  gem "capybara"
  gem "capybara-screenshot"
  gem "cuprite"
  gem "ffaker"
  gem "launchy"
end

group :development do
  gem "dockerfile-rails"
  gem "lefthook"
  gem "listen"
  gem "web-console"
end
