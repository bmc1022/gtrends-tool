require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test '#svg_icon displays an inline svg reference' do
    assert_equal '<svg class="test"><use xlink:href="#icon"></use></svg>', 
                 svg_icon('#icon', 'test')
  end
  
  test '#full_title returns a page title with site name appended' do
    assert_equal 'Test Title - GoogleTrends Keyword Planner', full_title('Test Title') 
  end
  
  test '#desc_5y_avg sorts the keyword averages of a trend from highest to lowest' do
    trend = create(:gtrend)
    keywords = create_list(:keyword, 10, :with_random_averages, gtrend: trend)
    averages = desc_5y_avg(trend).pluck(:avg_5y)
    assert_equal averages.sort.reverse, averages
  end
  
  test '#data_to_csv converts array to csv format' do
    trend = create(:gtrend)
    keywords = create_list(:keyword, 3, :with_averages, gtrend: trend)
    data = trend.keywords.sort_by(&:avg_5y).reverse!.pluck(:kw, :avg_5y)
    assert_equal "kw3,3\nkw2,2\nkw1,1\n", data_to_csv(data)
  end
  
  test '#trend_strength adds css classes to conditionally style trend averages' do
    assert_equal ['trend-avg', 'high-avg'], trend_strength(100, 75)
    assert_equal ['trend-avg', 'mid-avg'],  trend_strength(100, 50)
    assert_equal ['trend-avg', 'low-avg'],  trend_strength(100, 20)
    assert_equal ['trend-avg', nil],        trend_strength(100, 10)
  end
  
end
