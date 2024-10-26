import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="share"
export default class extends Controller {
  static values = { data: Object, fallbackCopyFeedback: String };
  static targets = ["fallbackCopyFeedback"];

  async share(event) {
    event.preventDefault();

    try {
      await navigator.share(shareData);
    } catch (error) {
      // Fallback to the clipboard
      navigator.clipboard.writeText(this.dataValue.url);
      this.fallbackCopyFeedbackTarget.text = this.fallbackCopyFeedbackValue;
    }
  }
}
