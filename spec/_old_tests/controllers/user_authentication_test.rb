# frozen_string_literal: true

require "test_helper"

class UserAuthenticationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  before { @user = create(:user) }

  test "should redirect to index after login" do
    sign_in(@user)
    get new_user_session_url
    assert_redirected_to gtrends_url
  end

  test "should redirect to login page after logout" do
    sign_in(@user)
    delete destroy_user_session_url
    get gtrends_url
    assert_redirected_to new_user_session_url
  end

  test "require authentication to view index" do
    get gtrends_url
    assert_redirected_to new_user_session_url
    sign_in(@user)
    get gtrends_url
    assert_response :success
  end
end
