# frozen_string_literal: true

require "rails_helper"

RSpec.describe(User, type: :model) do
  subject(:user) { build(:user) }

  include_examples "factory", :user
  include_examples "rolify",  :user

  describe "attributes and indexes" do
    # Database columns
    it { is_expected.to have_db_column(:email).of_type(:string) }
    it { is_expected.to have_db_column(:username).of_type(:string) }

    it { is_expected.to have_db_column(:encrypted_password).of_type(:string)
                                                           .with_options(default: "", null: false) }

    it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }

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

  describe "callbacks" do
    it { is_expected.to callback(:assign_default_role).before(:create) }
  end

  describe "associations" do
    it { is_expected.to have_many(:gtrends).dependent(:destroy) }
  end

  describe "validations" do
    describe ":username validations" do
      it {
        is_expected.to validate_uniqueness_of(:username)
                       .case_insensitive
                       .allow_blank
                       .with_message(/The username '.+' is already in use, please try another/)
      }

      it { is_expected.to validate_length_of(:username)
                          .is_at_least(2)
                          .is_at_most(100)
                          .with_message("Username should be between 2 to 100 characters") }
    end

    describe ":email validations" do
      it {
        is_expected.to validate_uniqueness_of(:email)
                       .case_insensitive
                       .with_message(/The email address '.+' is already in use, please try another/)
      }

      it { is_expected.to validate_length_of(:email)
                          .is_at_least(4)
                          .is_at_most(254)
                          .with_message("Email address should be between 4 to 254 characters") }

      describe "email formatting" do
        valid_emails = [
          "email@domain.com",
          "firstname.lastname@domain.com",
          "email@subdomain.domain.com",
          "firstname+lastname@domain.com",
          "email@123.123.123.123",
          "1234567890@domain.com",
          "email@domain-one.com",
          "_______@domain.com",
          "email@domain.name",
          "email@domain.co.jp",
          "firstname-lastname@domain.com"
        ]

        invalid_emails = [
          "plainaddress",
          '#@%^%#$@#$@#.com',
          "@domain.com",
          "email.domain.com",
          "email@domain@domain.com"
        ]

        valid_emails.each do |email|
          it "accepts the valid email format: #{email}" do
            user.email = email
            expect(user).to be_valid
            expect(user.errors[:email]).to be_empty
          end
        end

        invalid_emails.each do |email|
          it "rejects the invalid email format: #{email}" do
            user.email = email
            expect(user).not_to be_valid
            expect(user.errors[:email]).to include(/is not a valid email format/)
          end
        end
      end
    end

    describe ":password validations" do
      it { is_expected.to validate_presence_of(:password).with_message("A password is required") }

      it { is_expected.to validate_length_of(:password)
                          .is_at_least(6)
                          .is_at_most(128)
                          .with_message("Your password should be between 6 to 128 characters") }

      it { is_expected.to validate_confirmation_of(:password)
                          .with_message("Password confirmation does not match") }
    end

    describe ":password_confirmation validations" do
      it { is_expected.to validate_presence_of(:password_confirmation)
                          .with_message("Password confirmation is required") }

      it { is_expected.to validate_length_of(:password_confirmation)
                          .is_at_most(128)
                          .with_message("Password confirmation should not exceed 128 characters") }
    end

    describe ":presence_of_username_or_email validation" do
      let(:user) { build(:user, username:, email:) }

      before { user.send(:presence_of_username_or_email) }

      context "when both a username and email are present" do
        let(:username) { "testuser" }
        let(:email)    { "test@email.com" }

        it "is valid" do
          expect(user).to be_valid
          expect(user.errors).to be_empty
        end
      end

      context "when only a username is present" do
        let(:username) { "testuser" }
        let(:email)    { nil }

        it "is valid" do
          expect(user).to be_valid
          expect(user.errors).to be_empty
        end
      end

      context "when only an email is present" do
        let(:username) { nil }
        let(:email)    { "test@email.com" }

        it "is valid" do
          expect(user).to be_valid
          expect(user.errors).to be_empty
        end
      end

      context "when a username or email are not provided" do
        let(:username) { nil }
        let(:email)    { nil }

        it "adds an error to the user" do
          expect(user).to be_invalid
          expect(user.errors[:base]).to include("A user must have either a username or an email.")
        end
      end
    end

    describe ":role_assigned validation" do
      let(:new_user) do
        described_class.build(
          email: "test@email.com", password: "password", password_confirmation: "password"
        )
      end

      it "ensures that a role is assigned to a user on update" do
        new_user.save!
        expect(new_user.roles).to be_present
        new_user.update!(email: "new@email.com")
        expect(new_user).to be_valid
        new_user.roles.delete_all
        expect { new_user.update!(email: "ab@c.com") }.to raise_error(ActiveRecord::RecordInvalid)
        expect(new_user.errors[:user]).to include("User must be assigned a role")
      end

      it "does not apply the validation to newly created users" do
        expect(new_user.roles).to be_empty
        expect(new_user).to be_valid
      end
    end
  end

  describe "role assignment" do
    describe "#assign_default_role :before_create callback" do
      let(:new_user) do
        described_class.build(
          email: "test@email.com", password: "password", password_confirmation: "password"
        )
      end

      it "assigns a default :registered role on user creation" do
        expect(new_user.roles).to be_empty
        new_user.save!
        expect(new_user.roles.pluck(:name)).to contain_exactly("registered")
      end

      it "does not assign the default :registered role if a role is already present on user" do
        new_user.add_role(:admin)
        expect(new_user.roles.map(&:name)).to contain_exactly("admin")
        new_user.save!
        expect(new_user.roles.pluck(:name)).to contain_exactly("admin")
      end
    end

    context "when adding a new role to user" do
      let(:default_role) { Role.find_by(name: :registered) }
      let(:new_role)     { create(:role) }

      it "removes any existing roles before adding a new role" do
        expect(user.roles).to contain_exactly(default_role)

        user.add_role(new_role.name)
        expect(user.roles).not_to include(default_role)
        expect(user.roles).to contain_exactly(new_role)
      end
    end
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
