require 'test_helper'

class GtrendsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper
  
  setup do
    @user = create(:user)
    sign_in(@user)
  end
  
  test 'should get index' do
    get gtrends_url
    assert_response :success
  end
  
  test 'should create gtrend' do
    assert_difference('Gtrend.count') do
      post gtrends_url, params: { gtrend: { name: 'test', kws: ['lorem', 'ipsum'] } }
    end
    assert_no_enqueued_jobs
  end
  
  test 'should reject invalid gtrend creation' do
    
  end
  
  test 'should destroy gtrend' do
    
  end
  
end
