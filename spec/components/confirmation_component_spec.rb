require "rails_helper"

RSpec.describe ConfirmationComponent, type: :component do
  it "gives the button what the dialog needs" do
    component = described_class.new(id: "confirm-reset", title: "Clear everything?", button: "Yes, clear everything")

    expect(component.data).to eq(
      turbo_confirm: "Clear everything?",
      confirm_button: "Yes, clear everything",
      confirm_details: "confirm-reset"
    )
  end

  it "renders the guarded button after the details template" do
    render_inline(described_class.new(id: "confirm-it", title: "Sure?", button: "Yes")) do |confirmation|
      %(<button data-turbo-confirm="#{confirmation.title}">Go</button>).html_safe
    end

    expect(page).to have_css("template#confirm-it", visible: :all)
    expect(page).to have_css("button[data-turbo-confirm='Sure?']", text: "Go")
  end

  it "lists what goes and what stays, with a warning and a note" do
    render_inline(described_class.new(
      id: "confirm-it",
      title: "Sure?",
      button: "Yes",
      icon: :trash,
      removed: ["Ideas are deleted", nil],
      kept: ["Members stay"],
      warning: "Names were drawn",
      note: "This can't be undone."
    ))

    details = template_content("confirm-it")
    expect(details).to have_css("[data-confirm-icon] svg.icon-trash")
    expect(details).to have_css("li:has(.icon-x-mark)", text: "Ideas are deleted")
    expect(details).to have_css("li:has(.icon-check)", text: "Members stay")
    expect(details).to have_css("li", count: 2)
    expect(details).to have_text("Names were drawn")
    expect(details).to have_text("This can't be undone.")
  end

  context "when only a title is given" do
    it "leaves the details empty" do
      render_inline(described_class.new(id: "confirm-it", title: "Sure?", button: "Yes"))

      details = template_content("confirm-it")
      expect(details).to have_no_css("[data-confirm-icon], ul, div, p")
    end
  end
end
