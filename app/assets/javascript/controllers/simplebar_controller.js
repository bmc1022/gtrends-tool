import { Controller } from "@hotwired/stimulus"
import SimpleBar from 'simplebar'

export default class extends Controller {
  static targets = ["scrollbar"]

  connect() {
    this.simpleBars = this.scrollbarTargets.map((scrollbar) => new SimpleBar(scrollbar))
  }

  disconnect() {
    this.simpleBars.forEach((simplebar) => {
      simplebar.remove()
    })
    this.simpleBars = []
  }
}
