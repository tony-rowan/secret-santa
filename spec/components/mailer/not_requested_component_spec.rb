require "rails_helper"

RSpec.describe Mailer::NotRequestedComponent, type: :component do
  it "reassures people who didn't ask for the email" do
    render_inline(described_class.new(message: "Ignore this email and nothing will change."))

    expect(page).to have_text("Didn’t ask for this? Ignore this email and nothing will change.")
  end
end
