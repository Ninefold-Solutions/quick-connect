import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.content = this.element.getAttribute("data-tooltip-content");
    if (!this.content) return;

    this.tooltip = document.createElement("div");
    this.tooltip.className = "tooltip-popup";
    this.tooltip.innerHTML = this.content;

    this.showHandler = this.show.bind(this);
    this.hideHandler = this.hide.bind(this);
    this.element.addEventListener("mouseenter", this.showHandler);
    this.element.addEventListener("mouseleave", this.hideHandler);
  }

  disconnect() {
    this.element.removeEventListener("mouseenter", this.showHandler);
    this.element.removeEventListener("mouseleave", this.hideHandler);
    this.hide();
  }

  show() {
    document.body.appendChild(this.tooltip);
    const rect = this.element.getBoundingClientRect();
    this.tooltip.style.top = `${rect.top + window.scrollY - this.tooltip.offsetHeight - 6}px`;
    this.tooltip.style.left = `${rect.left + window.scrollX + rect.width / 2 - this.tooltip.offsetWidth / 2}px`;
    this.tooltip.classList.add("visible");
  }

  hide() {
    this.tooltip.classList.remove("visible");
    if (this.tooltip.parentNode) this.tooltip.parentNode.removeChild(this.tooltip);
  }
}
