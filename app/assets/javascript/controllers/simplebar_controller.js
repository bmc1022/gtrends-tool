import { Controller } from "@hotwired/stimulus"
import SimpleBar from 'simplebar'

export default class extends Controller {
  static targets = ["scrollbar"]

  connect() {
    this.simpleBars = this.scrollbarTargets.map((scrollbar) => {
      scrollbar.classList.remove('simplebar-init')
      new SimpleBar(scrollbar)
    })
  }

  disconnect() {
    this.simpleBars.forEach((simplebar) => {
      simplebar.remove()
    })
    this.simpleBars = []
  }
}
