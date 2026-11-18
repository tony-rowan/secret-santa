require "rails_helper"

RSpec.describe "GET /dashboard" do
  context "when signed in" do
    it "links to the account page from the header" do
      user = create(:user)

      authenticate(user)
      get dashboard_path

      expect(response.body).to include(%(href="#{edit_user_path(user)}"))
    end
  end
end
