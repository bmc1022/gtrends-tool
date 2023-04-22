# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Authentication", type: :system) do
  before_all { @user = create(:user) }

  it "allows a user to sign in" do
    visit gtrends_path
    click_link "Sign In"
    fill_in "user[login]", with: @user.username
    fill_in "Password", with: @user.password
    click_button "Sign in"

    expect(page).to have_text("Signed in successfully.")
    expect(page).to have_current_path(gtrends_path)
  end

  it "allows a user to sign out" do
    sign_in(@user)

    visit gtrends_path
    click_button "Sign Out"

    expect(page).to have_text("Signed out successfully.")
    expect(page).to have_current_path(gtrends_path)
  end
end
