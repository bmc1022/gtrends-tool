# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Admin::Dashboard", type: :request) do
  describe "GET admin/dashboard#dashboard" do
    before do
      sign_in(user) if user.present? && user.respond_to?(:encrypted_password)
      get(admin_dashboard_path)
    end

    context "when user is an administrator" do
      let(:user) { create(:user, :admin) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is a registered user" do
      let(:user) { create(:user) }

      it "redirects to the home page" do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user is a guest" do
      let(:user) { build(:guest) }

      it "redirects to the home page" do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end

    context "when user does not exist" do
      let(:user) { nil }

      it "redirects to the home page" do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
