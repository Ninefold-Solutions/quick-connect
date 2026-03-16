import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "icon"];

  toggle() {
    const isPassword = this.inputTarget.type === "password";
    this.inputTarget.type = isPassword ? "text" : "password";
    if (this.hasIconTarget) {
      this.iconTarget.className = isPassword
        ? "cursor-pointer fa fa-eye"
        : "cursor-pointer fa-regular fa-eye-slash";
    }
  }
}
