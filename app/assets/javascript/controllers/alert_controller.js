import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.fadeOut();
    }, 3000);
  }

  fadeOut() {
    if (this.element) {
      this.element.style.opacity = "0";
      setTimeout(() => {
        if (this.element) {
          this.element.remove();
        }
      }, 1000);
    }
  }
}
