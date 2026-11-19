import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";

// Replaces the browser's confirm() for data-turbo-confirm with a styled <dialog>. The submitter
// (or its form) can also set:
//   data-confirm-button   label for the confirming button (default "Confirm")
//   data-confirm-details  id of a <template> whose content is shown under the title; an element
//                         in it marked data-confirm-icon is shown above the title instead
// Connects to data-controller="confirm-dialog"
export default class extends Controller {
  static targets = ["icon", "title", "details", "confirmButton"];

  connect() {
    Turbo.config.forms.confirm = (message, form, submitter) =>
      this.confirm(message, submitter || form);
  }

  confirm(message, source) {
    const options = { ...source.closest("form")?.dataset, ...source.dataset };

    this.titleTarget.textContent = message;
    this.confirmButtonTarget.textContent = options.confirmButton || "Confirm";
    const details = this.details(options.confirmDetails);
    const icon = details.querySelector("[data-confirm-icon]");
    this.iconTarget.replaceChildren(...(icon ? [icon] : []));
    this.detailsTarget.replaceChildren(details);

    this.element.returnValue = "";
    this.element.showModal();

    return new Promise((resolve) => {
      this.element.addEventListener(
        "close",
        () => resolve(this.element.returnValue === "confirm"),
        { once: true },
      );
    });
  }

  // Clicking the backdrop (outside the panel) cancels
  backdropClick(event) {
    if (event.target === this.element) this.element.close("cancel");
  }

  details(templateId) {
    const template = templateId && document.getElementById(templateId);

    return template
      ? template.content.cloneNode(true)
      : document.createDocumentFragment();
  }
}
