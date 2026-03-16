import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["menu"];

    connect() {
        this.clickOutsideHandler = this.clickOutside.bind(this);
        this.keydownHandler = this.keydown.bind(this);
        document.addEventListener("click", this.clickOutsideHandler);
        document.addEventListener("keydown", this.keydownHandler);
    }

    disconnect() {
        document.removeEventListener("click", this.clickOutsideHandler);
        document.removeEventListener("keydown", this.keydownHandler);
    }

    toggle() {
        this.menuTarget.classList.toggle("hidden");
    }

    close() {
        this.menuTarget.classList.add("hidden");
    }

    clickOutside(event) {
        if (!this.element.contains(event.target)) {
            this.close();
        }
    }

    keydown(event) {
        if (event.key === "Escape") {
            this.close();
        }
    }
}
