import { Controller } from "@hotwired/stimulus";

// Builds a list of rules on a form before the group exists. Each rule is a hidden input; the
// text field shares their name, so a rule typed but not added is still submitted.
// Connects to data-controller="rule-list"
export default class extends Controller {
  static targets = ["list", "input", "template"];

  add(event) {
    event.preventDefault();

    const text = this.inputTarget.value.trim();
    if (text === "") return;

    const item = this.templateTarget.content.firstElementChild.cloneNode(true);
    item.querySelector("[data-rule-text]").textContent = text;
    item.querySelector("input").value = text;
    const removeButton = item.querySelector("button");
    removeButton.setAttribute("aria-label", `Remove rule: ${text}`);
    removeButton.setAttribute("title", `Remove rule: ${text}`);
    this.listTarget.append(item);

    this.inputTarget.value = "";
    this.inputTarget.focus();
  }

  remove(event) {
    event.preventDefault();

    event.currentTarget.closest("li").remove();
    this.inputTarget.focus();
  }
}
