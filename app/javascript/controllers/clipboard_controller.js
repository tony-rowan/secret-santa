import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="clipboard"
export default class extends Controller {
  static values = { text: String, feedback: String };
  static targets = ["label"];

  async copy(event) {
    event.preventDefault();

    await navigator.clipboard.writeText(this.textValue);
    this.labelTarget.textContent = this.feedbackValue;
  }
}
