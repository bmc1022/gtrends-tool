# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Sidekiq Web UI", type: :request) do
  describe "GET /sidekiq" do
    before do
      sign_in(user) if user.present?
      get(sidekiq_web_path)
    end

    context "when user is an administrator" do
      let(:user) { create(:user, :admin) }

      it "returns http success" do
        expect(response).to have_http_status(:success)
      end
    end

    context "when user is a registered user" do
      let(:user) { create(:user) }

      it "redirects to the user login page" do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/login")
      end
    end

    context "when user is a guest" do
      let(:user) { nil }

      it "redirects to the user login page" do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to("/login")
      end
    end
  end
end
