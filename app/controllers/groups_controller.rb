class GroupsController < ApplicationController
  before_action :require_logged_in
  before_action :require_owner, only: %i[edit update destroy]

  def show
    @group = group
  end

  def new
    @group = Group.new
  end

  def edit
    @group = group
  end

  def create
    @group = Group.new(create_group_params)

    if @group.save
      Current.group = @group
      redirect_to @group
    else
      render :new
    end
  end

  def update
    @group = group

    if params[:assign_partners]
      @group.assign_partners
      return redirect_to dashboard_path, notice: "Secret Santa partners assigned!"
    end

    if params[:kick_user_id]
      user = User.find(params[:kick_user_id])
      @group.kick(user)
      return redirect_to @group, notice: "User removed from group!"
    end

    if @group.update(update_group_params)
      redirect_to @group
    else
      render :edit
    end
  end

  def destroy
    group.destroy
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
    redirect_to(root_path) unless Current.user == group.owner
  end

  def group
    @group ||= Group.find(params[:id])
  end
end
