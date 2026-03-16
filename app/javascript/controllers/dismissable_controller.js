import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { delay: { type: Number, default: 2000 } };

  connect() {
    setTimeout(() => {
      this.element.style.display = "none";
    }, this.delayValue);
  }
}
