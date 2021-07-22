import { Tooltip } from 'bootstrap'

App.Tooltip = {
  
  init() {
    // initialize all bootstrap tooltips
    new Tooltip(document.body, {
      selector: '[data-bs-toggle="tooltip"]'
    });
  },

  keywords_copied() {
    document.addEventListener('click', (e) => {
      const clipboard = e.target.closest('.clipboard');
      if (clipboard) {
        clipboard.setAttribute('data-bs-original-title', 'Data Copied!');
        const el = Tooltip.getInstance(clipboard);
        el.show();
        clipboard.setAttribute('data-bs-original-title', 'Copy Data');
      }
    });
  }
  
};

document.addEventListener('turbolinks:load', () => { 
  App.Tooltip.init();
  App.Tooltip.keywords_copied();
});
