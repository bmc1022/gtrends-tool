# frozen_string_literal: true

require "test_helper"

class GtrendsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  before do
    @user = create(:user)
    sign_in(@user)
  end

  test "should get index" do
    get gtrends_url
    assert_response :success
  end

  test "should create gtrend" do
    assert_difference("Gtrend.count", 1) do
      post gtrends_url, params: { gtrend: { name: "test1", kws: "lorem, ipsum" }, format: :js }
      assert_includes @response["Content-Type"], "text/javascript"
      assert_enqueued_jobs(1)
    end
    assert_difference("Gtrend.count", 1) do
      post gtrends_url, params: { gtrend: { name: "test2", kws: "lorem, ipsum" }, format: :html }
      assert_includes @response["Content-Type"], "text/html"
      assert_redirected_to gtrends_url
      assert_enqueued_jobs(2)
    end
  end

  test "should reject invalid gtrend creation" do
    assert_no_difference("Gtrend.count") do
      post gtrends_url, params: { gtrend: { name: "", kws: "lorem, ipsum" } }
    end
    assert_no_enqueued_jobs
  end

  test "should destroy gtrend" do
    trend = create(:gtrend)
    assert_difference("Gtrend.count", -1) do
      delete gtrend_url(trend, format: :html)
      assert_includes @response["Content-Type"], "text/html"
      assert_redirected_to gtrends_url
    end
  end
end
