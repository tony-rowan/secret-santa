class HomeController < ApplicationController
  layout "authentication"

  before_action :redirect_logged_in_users_to_dashboard

  private

  def redirect_logged_in_users_to_dashboard
    redirect_to dashboard_path if logged_in?
  end
end
