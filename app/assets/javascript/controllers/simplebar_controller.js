import { Controller } from "@hotwired/stimulus"
import SimpleBar from "simplebar"

export default class extends Controller {
  static targets = ["scrollbar"]

  connect() {
    this.simpleBars = this.scrollbarTargets.map((scrollbar) => {
      // The simplebar-init class hides all scrollbars to prevent seeing the defaults flash on load.
      scrollbar.classList.remove("simplebar-init")
      return new SimpleBar(scrollbar)
    })
  }

  disconnect() {
    this.simpleBars.forEach((simpleBar) => {
      const wrapper = simpleBar.getScrollElement().closest(".simplebar-wrapper")
      if (wrapper) {
        wrapper.outerHTML = wrapper.querySelector(".simplebar-content").innerHTML
      }
    })
    this.simpleBars = []
  }
}
