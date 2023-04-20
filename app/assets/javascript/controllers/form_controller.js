import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  handleSubmitEnd(event) {
    const { success, fetchResponse } = event.detail

    if (!success) {
      fetchResponse.response.json().then(errors => {
        this.displayErrors(errors)
      })
    }
  }

  displayErrors(errors) {
    // Clear existing error tooltips
    this.element.querySelectorAll(".is-invalid").forEach(input => {
      input.classList.remove("is-invalid")
    })

    // Loop through the errors and set the error tooltip for each input field
    Object.keys(errors).forEach(field => {
      const input = this.element.querySelector(`[name="gtrend[${field}]"]`)
      const tooltip = this.element.querySelector(`[name="gtrend[${field}]"]`).nextElementSibling

      if (input) {
        const firstError = errors[field][0]

        // Add the error tooltip
        input.classList.add("is-invalid")
        tooltip.textContent = firstError

        // Add an event listener to hide the tooltip when the input changes
        input.addEventListener("input", this.handleInput)
      }
    })
  }

  handleInput(event) {
    const input = event.target
    input.classList.remove("is-invalid")
    input.removeEventListener("input", this.handleInput)
  }
}
