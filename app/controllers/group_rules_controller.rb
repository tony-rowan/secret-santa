class GroupRulesController < ApplicationController
  include GroupOwnerRequired

  def create
    rule = group.rules.build(text: params.dig(:rule, :text))

    if rule.save
      redirect_to dashboard_path
    else
      redirect_to dashboard_path, error: rule.errors[:text].first
    end
  end

  def destroy
    group.rules.find(params[:id]).destroy

    redirect_to dashboard_path
  end
end
