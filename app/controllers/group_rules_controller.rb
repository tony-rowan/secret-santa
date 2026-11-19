class GroupRulesController < ApplicationController
  include GroupOwnerRequired

  def create
    rule = group.rules.build(text: params.dig(:rule, :text))

    # The form checks for a blank or over-long rule before it's sent
    rule.save

    redirect_to dashboard_path
  end

  def destroy
    group.rules.find(params[:id]).destroy

    redirect_to dashboard_path
  end
end
