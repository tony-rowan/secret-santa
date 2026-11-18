module GroupOwnerRequired
  extend ActiveSupport::Concern

  included do
    before_action :require_authenticated_user
    before_action :require_group_owner
  end

  private

  def require_authenticated_user
    return if Current.user

    redirect_to root_path, error: "You must be signed in to do that"
  end

  def require_group_owner
    return if group.owner?(Current.user)

    redirect_to dashboard_path, error: "You're not allowed to do that"
  end

  def group
    @_group ||= Group.find(params[:group_id])
  end
end
