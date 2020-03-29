class GtrendsApi < ApplicationService

  def initialize(name, keywords)
    @name = name
    @keywords = keywords
  end
  
  def call
    
    @keywords.each do 
      
    end
    
    @keywords.first(5)
    
    url =  'https://www.trends.google.com/trends/explore?'
    url += 'geo=US' #region data
    url += '&date=today%205-y' #past 5 years
    url += '&q=' + @keywords.join(',').sub(' ','%20')
    
    response = HTTP.get(url)
    
    
  end
  
  private
  
    def find_top3(keywords)
      
    end
    
end