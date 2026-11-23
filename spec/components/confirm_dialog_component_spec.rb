require "rails_helper"

RSpec.describe ConfirmDialogComponent, type: :component do
  it "renders the dialog the confirm controller fills in" do
    render_inline(described_class.new)

    dialog = page.find("dialog[data-controller='confirm-dialog']", visible: :all)
    expect(dialog).to have_button("Confirm", visible: :all)
    expect(dialog).to have_button("Cancel", visible: :all)
  end
end
