import { Controller } from "@hotwired/stimulus";

const EYE_ICON = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-5 w-5"><path d="M12 5c5.8 0 9.4 4.82 9.55 5.02a1.75 1.75 0 010 1.96C21.4 12.18 17.8 17 12 17s-9.4-4.82-9.55-5.02a1.75 1.75 0 010-1.96C2.6 9.82 6.2 5 12 5zm0 1.5c-4.6 0-7.72 3.62-8.3 4.5.58.88 3.7 4.5 8.3 4.5s7.72-3.62 8.3-4.5c-.58-.88-3.7-4.5-8.3-4.5zm0 1.75a2.75 2.75 0 110 5.5 2.75 2.75 0 010-5.5z"/></svg>`;
const EYE_SLASH_ICON = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" class="h-5 w-5"><path d="M3.28 2.22a.75.75 0 011.06 0l17.44 17.44a.75.75 0 01-1.06 1.06l-2.39-2.39A11.38 11.38 0 0112 20c-5.8 0-9.4-4.82-9.55-5.02a1.75 1.75 0 010-1.96 19.54 19.54 0 013.8-3.74L3.28 3.28a.75.75 0 010-1.06zM7.4 10.46a4.25 4.25 0 005.64 5.64l-1.19-1.19a2.75 2.75 0 01-3.26-3.26L7.4 10.46zm4.22-4.9c.13-.01.25-.01.38-.01 5.8 0 9.4 4.82 9.55 5.02a1.75 1.75 0 010 1.96 19.4 19.4 0 01-2.1 2.45l-1.08-1.08c.63-.63 1.15-1.27 1.53-1.84-.58-.88-3.7-4.5-8.3-4.5-.63 0-1.23.07-1.81.2l-1.23-1.23a8.9 8.9 0 013.06-.97z"/></svg>`;

export default class extends Controller {
    static targets = ["input", "icon"];

    connect() {
        if (this.hasIconTarget && this.iconTarget.innerHTML.trim() === "") {
            this.iconTarget.innerHTML = EYE_SLASH_ICON;
        }
    }

    toggle() {
        const isPassword = this.inputTarget.type === "password";
        this.inputTarget.type = isPassword ? "text" : "password";

        if (this.hasIconTarget) {
            this.iconTarget.innerHTML = isPassword ? EYE_ICON : EYE_SLASH_ICON;
        }
    }
}
