require "capybara/rspec"
require "capybara/cuprite"
require "capybara-screenshot/rspec"

Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1200, 800], process_timeout: 30)
end

Capybara.register_driver(:cuprite_debugging) do |app|
  Capybara::Cuprite::Driver.new(app, window_size: [1200, 800], process_timeout: 30, headless: false)
end

Capybara.javascript_driver = :cuprite
Capybara.default_driver = :cuprite

Capybara::Screenshot.prune_strategy = :keep_last_run

Capybara.default_normalize_ws = true
Capybara.asset_host = "http://localhost:3000"
Capybara.server = :puma, {Silent: true}

RSpec.configure do |config|
  config.around(:each, type: :feature, debug: true) do |example|
    Capybara.using_driver(:cuprite_debugging) do
      example.run
    end
  end
end
