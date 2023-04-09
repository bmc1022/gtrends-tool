# frozen_string_literal: true

require "rails_helper"

RSpec.describe(User, type: :model) do
  subject(:user) { build(:user) }

  include_examples "factory", :user

  describe "attributes and indexes" do
    # Database columns
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:username).of_type(:string) }
    it { is_expected.to have_db_column(:admin).of_type(:boolean).with_options(default: false) }
    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }

    it { is_expected.to have_db_column(:encrypted_password).of_type(:string)
                                                           .with_options(default: "", null: false) }

    # Database indexes
    it { is_expected.to have_db_index([:email]).unique }
    it { is_expected.to have_db_index([:username]).unique }

    describe "email index" do
      let(:email_index) do
        ActiveRecord::Base.connection.indexes(:users).find { |index| index.columns == ["email"] }
      end

      it "has the correct where clause" do
        expect(email_index.where).to eq("((email IS NOT NULL) AND ((email)::text <> ''::text))")
      end
    end

    describe "username index" do
      let(:username_index) do
        ActiveRecord::Base.connection.indexes(:users).find { |index| index.columns == ["username"] }
      end

      it "has the correct where clause" do
        expect(username_index.where).to eq(
          "((username IS NOT NULL) AND ((username)::text <> ''::text))"
        )
      end
    end
  end

  describe "associations" do
    it { is_expected.to have_many(:gtrends).dependent(:destroy) }
  end

  describe ".find_first_by_auth_conditions" do
    let!(:user_1) { create(:user, username: "user1", email: "u1@email.com") }
    let!(:user_2) { create(:user, username: "user2", email: "u2@email.com") }

    context "when provided with the login attribute" do
      it "finds a user by username" do
        expect(described_class.find_first_by_auth_conditions(login: "user1")).to eq(user_1)
      end

      it "finds a user by email" do
        expect(described_class.find_first_by_auth_conditions(login: "u2@email.com")).to eq(user_2)
      end
    end

    context "when the username attribute is nil" do
      it "finds a user by other conditions" do
        expect(described_class.find_first_by_auth_conditions(email: "u1@email.com")).to eq(user_1)
      end
    end

    context "when provided with the username attribute" do
      it "finds a user by username" do
        expect(described_class.find_first_by_auth_conditions(username: "user2")).to eq(user_2)
      end
    end
  end

  describe "#login" do
    it "returns the login attribute if set" do
      user.login = "custom login"
      expect(user.login).to eq("custom login")
    end

    it "returns the username if login attribute is not set" do
      user.username = "test_username"
      expect(user.login).to eq("test_username")
    end

    it "returns the email if both login and username attributes are not set" do
      user.username = nil
      user.email = "test@email.com"
      expect(user.login).to eq("test@email.com")
    end
  end
end
