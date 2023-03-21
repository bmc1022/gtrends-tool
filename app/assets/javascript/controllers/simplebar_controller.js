import { Controller } from "@hotwired/stimulus";
import SimpleBar from 'simplebar';

export default class extends Controller {
  connect() {
    new SimpleBar(this.element);
    this.element.classList.remove('simplebar-init');
  }
}
