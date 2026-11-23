require "rails_helper"

RSpec.describe Account::NameFormComponent, type: :component do
  it "shows the current name" do
    user = create(:user, name: "Bob")

    render_inline(described_class.new(user:))

    expect(page).to have_field("How you appear to your groups", with: "Bob")
    expect(page).to have_button("Save")
  end

  context "when the name is invalid" do
    it "shows the error" do
      user = create(:user)
      user.name = ""
      user.validate

      render_inline(described_class.new(user:))

      expect(page).to have_css("p.text-berry-light", text: "Please give yourself a name others would recognise")
      expect(page).to have_css("input.border-berry-light")
    end
  end
end
