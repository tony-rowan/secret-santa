ruby "3.3.5"

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "rails"

gem "bcrypt"
gem "bootsnap", require: false
gem "importmap-rails"
# Annoying issue with silencing a warning
gem "litestack", github: "oldmoe/litestack", branch: "master"
gem "puma"
gem "sprockets-rails"
gem "sqlite3"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"

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
