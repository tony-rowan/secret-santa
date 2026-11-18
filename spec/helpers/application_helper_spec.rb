require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#markdown" do
    it "renders headings, emphasis, lists and links" do
      html = helper.markdown("# Title\n\n*em* and **strong**\n\n- one\n- two\n\n[site](https://example.com)")

      expect(html).to include("<h1>Title</h1>")
      expect(html).to include("<em>em</em>", "<strong>strong</strong>")
      expect(html).to include("<li>one</li>", "<li>two</li>")
      expect(html).to include('<a href="https://example.com">site</a>')
    end

    it "renders tables and strikethrough" do
      html = helper.markdown("| a | b |\n|---|---|\n| 1 | 2 |\n\n~~gone~~")

      expect(html).to include("<table>", "<td>1</td>", "<del>gone</del>")
    end

    it "strips script tags" do
      html = helper.markdown("hi <script>alert(1)</script>")

      expect(html).not_to include("<script")
    end

    it "strips event handler attributes" do
      html = helper.markdown('<img src="x" onerror="alert(1)">')

      expect(html).not_to include("onerror")
      expect(html).not_to include("<img")
    end

    it "strips javascript: links" do
      html = helper.markdown("[click](javascript:alert(1))")

      expect(html).not_to include("javascript:")
    end

    it "is html safe" do
      expect(helper.markdown("hi")).to be_html_safe
    end

    it "returns an empty string for nil" do
      expect(helper.markdown(nil)).to eq("")
    end
  end
end
