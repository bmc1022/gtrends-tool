// start polling for processed results on newly created trends
App.Gtrends = {
  
  // on form submission, cycle through the 5 trends on each page, looking at the status data attribute
  // for each status == 'queued', use the id attribute to start a poll to fetch data for the specific trend
  // if any have a 'failed' status, delete trend from db and show a retry button
  
  poll() {
    setTimeout(this.request, 5000);
  },
  
  request() {
    //$.get($('').data('url'), { after: $('.trend').first().data('id') } );
  }
  
};

document.addEventListener('turbolinks:load', () => { 
  const el = document.querySelector('body.index');
  if (el.length == 0) { return }
});
