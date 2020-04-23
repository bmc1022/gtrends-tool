window.App || (window.App = {});

App.init = () => {
  Pagy.init(); // pagination
  new ClipboardJS('.clipboard'); // copy text to clipboard
}

$(document).on("turbolinks:load", () => { App.init() });
