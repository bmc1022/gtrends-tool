App.Tooltip = {
  
  init() {
    // add bootstrap tooltips
    $('body').tooltip({
      selector: '[data-toggle="tooltip"]',
      trigger: 'click'
    });
  },

  fade() {
    setTimeout(() => {
      $('[data-toggle="tooltip"]').tooltip('hide')
    }, 1500);
  }
  
}

$(document).on('turbolinks:load', () => { App.Tooltip.init() });
$(document).on('click', 'button.clipboard', () => { App.Tooltip.fade() });
