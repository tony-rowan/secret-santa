class ApplicationController < ActionController::Base
  include Authentication

  add_flash_types :success, :error
end
