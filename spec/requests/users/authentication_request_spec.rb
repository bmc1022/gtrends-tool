# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Authentication", type: :request) do
  describe "user authentication" do
    let(:user) { create(:user, username: "test", email: "test@email.com", password: "password") }

    context "when logging in" do
      context "when an administrator logs in" do
        let(:user) { create(:user, :admin) }

        it "logs in with valid username and password and redirects to admin dashboard" do
          post(new_user_session_path,
              params: { user: { login: user.username, password: user.password } })

          expect(response).to redirect_to(admin_dashboard_path)
          expect(flash[:notice]).to eq("Signed in successfully.")
        end

        it "logs in with valid email and password and redirects to admin dashboard" do
          post(new_user_session_path,
              params: { user: { login: user.email, password: user.password } })

          expect(response).to redirect_to(admin_dashboard_path)
          expect(flash[:notice]).to eq("Signed in successfully.")
        end
      end

      context "when a registered user logs in" do
        it "logs in with valid username and password and redirects to root path" do
          post(new_user_session_path,
              params: { user: { login: user.username, password: user.password } })

          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq("Signed in successfully.")
        end

        it "logs in with valid email and password and redirects to root path" do
          post(new_user_session_path,
              params: { user: { login: user.email, password: user.password } })

          expect(response).to redirect_to(root_path)
          expect(flash[:notice]).to eq("Signed in successfully.")
        end
      end

      it "does not log in with invalid username" do
        post(new_user_session_path,
             params: { user: { login: "wrong_username", password: user.password } })

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template("users/sessions/new")
        expect(flash[:alert]).to eq("Invalid Login or Password.")
      end

      it "does not log in with invalid email" do
        post(new_user_session_path,
             params: { user: { login: "wrong_email@email.com", password: user.password } })

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template("users/sessions/new")
        expect(flash[:alert]).to eq("Invalid Login or Password.")
      end

      it "does not log in with invalid password" do
        post(new_user_session_path, params: { user: { login: user.email, password: "wrong_pw" } })

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template("users/sessions/new")
        expect(flash[:alert]).to eq("Invalid Login or Password.")
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
