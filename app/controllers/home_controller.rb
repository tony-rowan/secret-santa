class HomeController < ApplicationController
  layout "authentication"

  before_action :redirect_logged_in_users_to_dashboard

  def show
    render locals: {
      group:
    }
  end

  private

  def redirect_logged_in_users_to_dashboard
    redirect_to dashboard_path if logged_in?
  end

  def group
    return @_group if defined?(@_group)

    @_group = Group.find_by(join_code:) if join_code
  end

  def join_code
    session[:join_code].presence
  end
end
