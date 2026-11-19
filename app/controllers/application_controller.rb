class ApplicationController < ActionController::Base
  include Authentication

  RATE_LIMIT_MESSAGE = "Too many attempts, please wait a few minutes and try again"
end
