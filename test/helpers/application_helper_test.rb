require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  
  test '#svg_icon displays an inline svg reference' do
    assert_equal '<svg class="test"><use xlink:href="#icon"></use></svg>', 
                 svg_icon('#icon', 'test')
  end
  
  test '#full_title returns a page title with site name appended' do
    assert_equal 'Test Title - GoogleTrends Keyword Planner', full_title('Test Title') 
  end
  
  test '#trend_strength adds css classes to conditionally style trend averages' do
    assert_equal ['trend-avg', 'high-avg'], trend_strength(100, 75)
    assert_equal ['trend-avg', 'mid-avg'],  trend_strength(100, 50)
    assert_equal ['trend-avg', 'low-avg'],  trend_strength(100, 20)
    assert_equal ['trend-avg', nil],        trend_strength(100, 10)
  end
  
end
