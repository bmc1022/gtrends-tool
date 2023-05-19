import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  handleSubmitEnd(event) {
    const { success } = event.detail;

    if (!success) {
      const errorsJSON = this.element.querySelector("[data-target='form-errors']").value;
      const errors = JSON.parse(errorsJSON);
      this.displayErrors(errors);

      // fetchResponse.response.text().then(html => {
      //   const parser = new DOMParser()
      //   const doc = parser.parseFromString(html, "text/html")
      //   const errorsJSON = doc.querySelector("#gtrend-form [name='gtrend[errors]']").value
      //   const errors = JSON.parse(errorsJSON)
      //   this.displayErrors(errors)
      // })
    }
  }

  displayErrors(errors) {
    // Clear existing error tooltips
    this.element.querySelectorAll(".is-invalid").forEach((input) => {
      input.classList.remove("is-invalid");
    });

    // Loop through the errors and set the error tooltip for each input field
    Object.keys(errors).forEach((field) => {
      const input = this.element.querySelector(`[name="gtrend[${field}]"]`);
      if (input && input.nextElementSibling) {
        const tooltip = input.nextElementSibling;

        // Add the error tooltip
        input.classList.add("is-invalid");
        tooltip.textContent = errors[field][0];

        // Add an event listener to hide the tooltip when the input changes
        input.addEventListener("input", this.handleInput);
      }
    });
  }

  handleInput(event) {
    const input = event.target;
    input.classList.remove("is-invalid");
    input.removeEventListener("input", this.handleInput);
  }
}
