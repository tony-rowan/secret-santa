import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="share"
export default class extends Controller {
  static values = { data: Object, fallbackCopyFeedback: String };
  static targets = ["fallbackCopyFeedback"];

  async share(event) {
    event.preventDefault();

    if (!navigator.share) return this.copyLink();

    try {
      await navigator.share(this.dataValue);
    } catch (error) {
      // Closing the share sheet isn't a failure, so only fall back for real errors
      if (error.name !== "AbortError") this.copyLink();
    }
  }

  copyLink() {
    navigator.clipboard.writeText(this.dataValue.url);
    this.fallbackCopyFeedbackTarget.textContent =
      this.fallbackCopyFeedbackValue;
  }
}
