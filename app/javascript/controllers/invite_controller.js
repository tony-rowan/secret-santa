import { Controller } from "@hotwired/stimulus";

// "Invite others": the device's share sheet where there is one, otherwise a dialog with the link
// to copy. Closing the share sheet isn't a failure, so only real errors fall back to the dialog.
// Connects to data-controller="invite"
export default class extends Controller {
  static values = { share: Object };
  static targets = ["dialog", "copyLabel"];

  async open() {
    if (this.canShare()) {
      try {
        await navigator.share(this.shareValue);
        return;
      } catch (error) {
        if (error.name === "AbortError") return;
      }
    }

    this.copyLabelTarget.textContent = "Copy link";
    this.dialogTarget.showModal();
  }

  close() {
    this.dialogTarget.close();
  }

  // Clicking the backdrop (outside the panel) closes
  backdropClick(event) {
    if (event.target === this.dialogTarget) this.close();
  }

  select(event) {
    event.target.select();
  }

  async copy() {
    await navigator.clipboard.writeText(this.shareValue.url);
    this.copyLabelTarget.textContent = "Link copied";
  }

  canShare() {
    if (!navigator.share) return false;

    return !navigator.canShare || navigator.canShare(this.shareValue);
  }
}
