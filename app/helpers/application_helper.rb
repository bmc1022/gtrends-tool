module ApplicationHelper
  
  # returns the full title on a per-page basis
  def full_title(page_title='')
    base_title = "Google Trends Bulk Keyword Comparison Tool"
    page_title.empty? ? base_title : "#{page_title} - #{base_title}"
  end

end
