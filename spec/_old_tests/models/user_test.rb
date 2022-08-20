# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  include Devise::Test::IntegrationHelpers

  test "has valid data" do
    user = build(:user)
    assert user.valid?
  end

  test "login method" do
    user = create(:user)
    assert_equal "user1", user.login
  end

  test "find user by email" do
    user = create(:user, email: "test@email.com")
    assert_equal user, User.find_first_by_auth_conditions({ login: "test@email.com" })
  end

  test "find user by username" do
    user = create(:user, username: "test")
    assert_equal user, User.find_first_by_auth_conditions({ login: "test" })
  end

  test "find user when login is not supplied" do
    user = create(:user, username: "test", email: "test@email.com")
    assert_equal user, User.find_first_by_auth_conditions({ email: "test@email.com" })
    assert_equal user, User.find_first_by_auth_conditions({ username: "test" })
  end
end
