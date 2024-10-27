class GroupsController < ApplicationController
  before_action :require_logged_in
  before_action :require_owner, only: %i[edit update destroy]

  def new
    render locals: {
      group: Group.new
    }
  end

  def edit
    group = fetch_group

    render locals: {
      group:
    }
  end

  def create
    group = Group.new(create_group_params)

    if group.save
      Current.group = group
      redirect_to(dashboard_path, success: "Group Created. Now invite some friends to join.")
    else
      render :new, status: :unprocessable_entity, locals: {
        group:
      }
    end
  end

  def update
    group = fetch_group

    if params[:assign_partners]
      if group.assign_partners
        return redirect_to dashboard_path, notice: "Secret Santa partners assigned!"
      else
        return redirect_to dashboard_path, error: "Could not assign secret santa partners"
      end
    end

    if params[:reassign_partners]
      if group.assign_partners
        return redirect_to dashboard_path, notice: "Secret Santa partners re-assigned!"
      else
        return redirect_to dashboard_path, error: "Could not re-assign secret santa partners"
      end
    end

    if group.update(update_group_params)
      redirect_to dashboard_path
    else
      render :edit, status: :unprocessable_entity, locals: {
        group:
      }
    end
  end

  def destroy
    group = fetch_group
    group.delete
    Current.group = Current.user.groups.last
    redirect_to root_url
  end

  private

  def create_group_params
    params.require(:group).permit(:name, :rules).merge(users: [Current.user], owner: Current.user)
  end

  def update_group_params
    params.require(:group).permit(:name, :rules)
  end

  def require_owner
    redirect_to(root_path) unless Current.user == fetch_group.owner
  end

  def fetch_group
    @_group ||= Group.find(params[:id])
  end
end
