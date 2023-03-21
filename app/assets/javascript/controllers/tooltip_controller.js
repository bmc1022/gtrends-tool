import { Controller } from "@hotwired/stimulus"
import { Tooltip } from "bootstrap"

export default class extends Controller {
  static targets = ["tooltip"]

  connect() {
    this.tooltips = this.tooltipTargets.map((tooltip) => new Tooltip(tooltip))
  }

  disconnect() {
    this.tooltips.forEach((tooltip) => tooltip.dispose())
  }

  clipboardTooltip(event) {
    let clipboard = event.currentTarget
    let tooltipInstance = Tooltip.getInstance(clipboard)
    tooltipInstance.setContent({".tooltip-inner": "Copied!"})
    setTimeout(() => {
      tooltipInstance.hide()
      tooltipInstance.setContent({".tooltip-inner": "Copy Data (CSV)"})
    }, 1000)
  }
}
