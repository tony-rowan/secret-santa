# frozen_string_literal: true

require "rails_helper"

RSpec.describe IconComponent, type: :component do
  it "renders an SVG element" do
    render_inline(described_class.new(:plus))

    expect(page).to have_css("svg")
  end

  it "merges additional classes with the size class and icon identifier class" do
    render_inline(described_class.new(:plus, class: "text-green-500"))

    expect(page).to have_css("svg.size-6.text-green-500.icon-plus")
  end

  it "stops the icon shrinking inside flex containers" do
    render_inline(described_class.new(:plus))

    expect(page).to have_css("svg.shrink-0")
  end

  context "when a custom size is given" do
    it "uses it in place of the default size class" do
      render_inline(described_class.new(:plus, size: "size-4"))

      expect(page).to have_css("svg.size-4:not(.size-6)")
    end
  end

  context "when no aria-label is given" do
    it "hides the icon from screen readers" do
      render_inline(described_class.new(:plus))

      expect(page).to have_css("svg[aria-hidden='true']:not([role])")
    end
  end

  context "when an aria-label is given" do
    it "exposes the icon as a labelled graphics-symbol" do
      render_inline(described_class.new(:plus, aria: {label: "Add item"}))

      expect(page).to have_css("svg[role='graphics-symbol'][aria-label='Add item']:not([aria-hidden])")
    end
  end

  context "when aria-hidden is explicitly false and there is no label" do
    it "honours it rather than forcing aria-hidden=true" do
      render_inline(described_class.new(:plus, aria: {hidden: false}))

      expect(page).to have_css("svg[aria-hidden='false']")
    end
  end

  context "when an explicit role is given and there is no label" do
    it "keeps the explicit role" do
      render_inline(described_class.new(:plus, role: "img"))

      expect(page).to have_css("svg[role='img'][aria-hidden='true']")
    end
  end

  context "when a label is given together with aria-hidden true" do
    it "keeps aria-hidden true" do
      render_inline(described_class.new(:plus, aria: {label: "Add item", hidden: true}))

      expect(page).to have_css("svg[aria-hidden='true'][aria-label='Add item'][role='graphics-symbol']")
    end
  end

  context "when the label is passed as a top-level attribute" do
    it "treats the icon as labelled" do
      render_inline(described_class.new(:plus, "aria-label": "Add item"))

      expect(page).to have_css("svg[role='graphics-symbol'][aria-label='Add item']:not([aria-hidden])")
    end
  end

  context "when the icon does not exist" do
    it "raises IconNotFoundError" do
      expect { render_inline(described_class.new(:nonexistent)) }
        .to raise_error(IconComponent::IconNotFoundError)
    end
  end
end
