# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Authentication", type: :request) do
  describe "user authentication" do
    let(:user) { create(:user, email: "test@email.com", password: "password") }

    context "when logging in" do
      it "successfully logs in with valid credentials" do
        post(new_user_session_path, params: { user: { email: user.email, password: "password" } })

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Signed in successfully.")
      end

      it "does not log in with invalid credentials" do
        post(new_user_session_path, params: { user: { email: user.email, password: "wrong_pw" } })

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template("users/sessions/new")
        expect(flash[:alert]).to eq("Invalid Email or password.")
      end
    end

    context "when logging out" do
      it "successfully logs out" do
        sign_in(user)
        delete(destroy_user_session_path)

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Signed out successfully.")
      end
    end
  end
end
