// start polling for processed results on newly created trends
App.Gtrends = {

  poll(status) {
    let count = 0;
    while (status !== 'done' || count <= 10) {
      console.log(status);
      count++;
    }
    // setTimeout(this.poll(), 1000);
  },
  
  updateTrend() {
    // on gtrend form submission, look for trends with a non-empty status
    // for each active trend, start a poll
    
    // if a 'done' status is found, change it to an empty string
    // if a 'failed' status is found, destroy trend and show a retry button
    // what happens when page is refreshed prematurely? if trend is blank, restart poll
    const newTrendForm = document.getElementById('new-trend');
    const activeTrends = document.querySelectorAll('.trend:not([data-status=""])');
    newTrendForm.addEventListener('ajax:send', (e) => {
      for (const trend of activeTrends) {
        const dataId = trend.getAttribute('data-id');
        let dataStatus = trend.getAttribute('data-status');
        
        this.poll(dataStatus)
        
        
        
        // let ajax = new XMLHttpRequest();
        // ajax.open('GET', )
        
        
        // start a poll that checks the status every 2 seconds for 5 minutes
        // if 'failed', 
        // if 'done', use data id to fetch trend data and replace html with gtrend partial
      }
    });
  }
  
};

document.addEventListener('turbolinks:load', () => { 
  const index = document.querySelector('body.index');
  if (!index) { return }
  // App.Gtrends.updateTrend();
});
