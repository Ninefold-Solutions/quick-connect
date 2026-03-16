import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    static targets = ["label"];

    update(event) {
        const files = event.target.files;
        if (files && files.length > 0) {
            this.labelTarget.textContent = Array.from(files).map(f => f.name).join(", ");
        } else {
            this.labelTarget.textContent = "Custom Upload";
        }
    }
}
