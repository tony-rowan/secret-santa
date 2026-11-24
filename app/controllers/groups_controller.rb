class GroupsController < ApplicationController
  layout "getting_started"

  before_action :require_logged_in
  before_action :require_owner, only: %i[created update destroy]

  def new
    render locals: {
      group: Group.new,
      user: Current.user
    }
  end

  def created
    render locals: {
      group: fetch_group
    }
  end

  def create
    group = Group.new(create_group_params)
    rule_texts.each { |text| group.rules.build(text:) }

    if group.save
      select_group(group)
      redirect_to(created_group_path(group))
    else
      render :new, status: :unprocessable_content, locals: {
        group:,
        user: Current.user
      }
    end
  end

  def update
    group = fetch_group

    # The draw needs 3 people; the dashboard disables the button until there are
    if params[:assign_partners] || params[:reassign_partners]
      group.assign_partners
      return redirect_to dashboard_path
    end

    # Renamed from the dashboard; the field is required, so a blank name only gets here without the browser's check
    group.update(update_group_params)

    redirect_to dashboard_path
  end

  def destroy
    group = fetch_group
    group.delete
    Current.group = Current.user.groups.last
    redirect_to root_url
  end

  private

  def create_group_params
    params.expect(group: [:name]).merge(users: [Current.user], owner: Current.user)
  end

  def update_group_params
    params.expect(group: [:name])
  end

  # Rules added on the create form before the group exists; blanks are dropped
  def rule_texts
    Array(params.dig(:group, :rule_texts)).map(&:to_s).map(&:squish).compact_blank
  end

  def require_owner
    redirect_to(root_path) unless Current.user == fetch_group.owner
  end

  def fetch_group
    @_group ||= Group.find(params[:id])
  end
end
