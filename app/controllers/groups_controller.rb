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
      @group.shuffle
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def update
    @group = group

    if @group.update(update_group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    group.destroy
    Current.group = Current.user.groups.last
    redirect_to root_url, notice: 'Group was successfully destroyed.'
  end

  private

  def create_group_params
    {
      name: params[:group][:name],
      users: users_from_params + [Current.user],
      owner: Current.user
    }
  end

  def users_from_params
    params[:group][:names].split(',').map(&:strip).map { User.new_user_for_invite(_1) }
  end

  def update_group_params
    params.require(:group).permit(:name)
  end

  def require_owner
    redirect_to(root_path) unless Current.user == group.owner
  end

  def group
    @group ||= Group.find(params[:id])
  end
end
