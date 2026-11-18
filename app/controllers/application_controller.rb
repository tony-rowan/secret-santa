class ApplicationController < ActionController::Base
  include Authentication

  add_flash_types :success, :error

  RATE_LIMIT_MESSAGE = "Too many attempts, please wait a few minutes and try again"
end
