module ApplicationHelper
  
  include Pagy::Frontend
  
  # returns the full title on a per-page basis
  def full_title(page_title='')
    base_title = "Google Trends Keyword Comparison Tool"
    page_title.empty? ? base_title : "#{page_title} - #{base_title}"
  end
  
  # conditional css classes for colorizing trend averages
  def trend_strength(max, avg)
    rel_to_highest = avg.to_f / max
    base_class = 'trend-avg'
    
    str_class = case rel_to_highest
      when 0.75..1.00 then 'high-avg'
      when 0.50..0.74 then 'mid-avg'
      when 0.20..0.49 then 'low-avg'
    end

    return [base_class, str_class]
  end

end
