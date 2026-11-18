import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="auto-submit"
// Submits the form it is attached to as soon as it appears on the page.
export default class extends Controller {
  connect() {
    this.element.requestSubmit();
  }
}
