require "rails_helper"

RSpec.describe Sessions::EmailFormComponent, type: :component do
  it "asks only for an email" do
    render_inline(described_class.new)

    expect(page).to have_field("Your email", type: "email")
    expect(page).to have_no_field(type: "password")
    expect(page).to have_button("Email me a sign-in link")
    expect(page).to have_text("New here? The same link creates your account.")
  end

  context "when there's an error" do
    it "shows it in the label and keeps the email" do
      render_inline(described_class.new(email: "not an email", error: "Please enter a valid email address"))

      expect(page).to have_css("label.text-berry-light", text: "Please enter a valid email address")
      expect(page).to have_field(with: "not an email", class: "border-berry-light")
    end
  end
end
