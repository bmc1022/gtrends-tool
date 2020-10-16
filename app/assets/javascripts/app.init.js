window.App || (window.App = {});

App.init = () => {
  new ClipboardJS('.clipboard'); // copy text to clipboard
}

$(document).on("turbolinks:load", () => { App.init() });
