class GroupsController < ApplicationController
  def show
    @group = Group.find(params[:id])
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)

    if @group.save
      redirect_to @group, notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def update
    @group = Group.find(params[:id])

    if @group.update(group_params)
      redirect_to @group, notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])

    @group.destroy
    redirect_to groups_url, notice: 'Group was successfully destroyed.'
  end

  def join
    @group = Group.find(params[:group_id])
    @group.join(Current.user)
    redirect_to @group, notice: 'Group was successfully joined'
  end

  def shuffle
    @group = Group.find(params[:group_id])
    @group.shuffle
    redirect_to @group, notice: 'Group pairings have been assigned'
  end

  private

  def group_params
    params.require(:group).permit(:name)
  end
end
