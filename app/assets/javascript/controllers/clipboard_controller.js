import { Controller } from "@hotwired/stimulus"
import ClipboardJS from "clipboard"

export default class extends Controller {
  connect() {
    this.clipboard = new ClipboardJS(this.element)
    this.clipboard.on("success", this.copySuccess.bind(this))
    this.clipboard.on("error", this.copyError.bind(this))
  }

  disconnect() {
    this.clipboard.destroy()
  }

  copySuccess(event) {
    event.clearSelection()
  }

  copyError(event) {
    event.clearSelection()
  }
}
