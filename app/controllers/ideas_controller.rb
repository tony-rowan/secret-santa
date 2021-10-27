class IdeasController < ApplicationController
  def new
    @idea = Idea.new(user: @user)
  end

  def create
    @idea = Idea.new(idea_params)

    if @idea.save
      redirect_to root_path, notice: "Your idea has been saved"
    else
      render :new
    end
  end

  private

  def idea_params
    params.require(:idea).permit(:idea).merge(user: Current.user)
  end
end
