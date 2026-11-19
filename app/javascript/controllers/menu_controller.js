import { Controller } from "@hotwired/stimulus";

// Closes a <details> popover menu on Escape or a click outside it
export default class extends Controller {
  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) this.close();
  }

  close() {
    if (!this.element.open) return;

    this.element.open = false;
    this.element.querySelector("summary")?.focus();
  }
}
