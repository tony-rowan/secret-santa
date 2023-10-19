import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="clipboard"
export default class extends Controller {
  static values = { data: String };
  static targets = ["confirmation"];

  copy(event) {
    event.preventDefault();
    navigator.clipboard.writeText(this.dataValue);
    this.confirmationTarget.classList.remove("invisible");
  }
}
