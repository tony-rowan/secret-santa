class JoinController < ApplicationController
  layout "getting_started"

  before_action :require_logged_in

  def new
    # Groups are only joined from an invite link; without one, the way in is starting a group
    return redirect_to(new_group_path) unless invite_token

    form = JoinGroup.new(invite_token:, user: Current.user)

    if form.already_member?
      select_group(form.group)
      redirect_to(dashboard_path)
    elsif form.valid?
      render :invitation, locals: {
        group: form.group,
        form: form
      }
    else
      render_not_joinable(form)
    end
  end

  def create
    form = JoinGroup.new(**join_group_params)

    if form.save
      select_group(form.group)

      redirect_to(dashboard_path)
    else
      render_not_joinable(form)
    end
  end

  private

  def invite_token
    return @_invite_token if defined?(@_invite_token)

    # A token in the URL wins over one from the session, but the session's is always cleaned up
    invite_token_from_session = session.delete(:invite_token)
    invite_token_from_params = params[:invite_token].presence

    @_invite_token = invite_token_from_params || invite_token_from_session
  end

  def join_group_params
    params.expect(join_group: [:invite_token]).merge(user: Current.user)
  end

  def render_not_joinable(form)
    if form.closed?
      render "shared/message", status: :forbidden, locals: {
        icon_name: :lock_closed,
        title: "Names have been drawn",
        subtitle: "#{form.group.name} isn't taking new members. If you should be in it, ask #{form.group.owner.name}.",
        **way_on
      }
    else
      render "shared/message", status: :not_found, locals: {
        icon_name: :link_slash,
        title: "That invite link doesn't work",
        subtitle: "Check you opened the whole link from the message you were sent, or ask your organiser to send it again.",
        **way_on
      }
    end
  end

  # Back to the dashboard for people with a group, otherwise starting one of their own
  def way_on
    if Current.user.groups.any?
      {link_text: "Back to your group", link_url: dashboard_path}
    else
      {link_text: "Start a new group", link_url: new_group_path}
    end
  end

  # Save the invite token into the session to allow it to follow the user through signing in and
  # choosing a display name
  def require_logged_in
    session[:invite_token] = params[:invite_token] if params[:invite_token].present?

    super
  end
end
