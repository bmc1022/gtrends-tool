# frozen_string_literal: true

require "application_system_test_case"

class GtrendsTest < ApplicationSystemTestCase
  include Devise::Test::IntegrationHelpers
  include ActiveJob::TestHelper

  before do
    @user = create(:user)
    sign_in(@user)
    @gtrends = create(:gtrend_with_keywords)
  end

  test "user creates new trend list" do
    visit gtrends_url
    within "#new-trend-form" do
      fill_in "gtrend_name", with: "test name"
      fill_in "gtrend_kws",  with: "one, two, three, four, five"
      click_on "Create New Trend"
    end
    take_screenshot
  end

  test "user deletes trend list" do
    visit gtrends_url
    within "#new-trend-form" do
      fill_in "gtrend_name", with: "test name"
      fill_in "gtrend_kws",  with: "one, two, three, four, five"
      click_on "Create New Trend"
    end
    take_screenshot
  end

  test "user copies data to clipboard"
  test "user performs a search"
  test "user navigates to new page using pagination"
end
