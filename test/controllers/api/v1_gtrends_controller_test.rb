require 'test_helper'

class V1GtrendsControllerTest < ActionDispatch::IntegrationTest
  
  test 'should get index' do
    get api_v1_gtrends_url
    assert_response :success
  end
  
end
