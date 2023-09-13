# frozen_string_literal: true

require "rails_helper"

RSpec.describe("CustomDeviseRoutes", type: :routing) do
  describe "authentication routes" do
    it "routes GET /login to the users/sessions controller" do
      expect(get: "/login").to route_to(controller: "users/sessions", action: "new")
    end

    it "routes POST /login to the users/sessions controller" do
      expect(post: "/login").to route_to(controller: "users/sessions", action: "create")
    end

    it "routes DELETE /logout to the users/sessions controller" do
      expect(delete: "/logout").to route_to(controller: "users/sessions", action: "destroy")
    end
  end

  describe "password reset routes" do
    it "routes GET /reset_password to the users/passwords controller" do
      expect(get: "/reset_password").to route_to(controller: "users/passwords", action: "new")
    end

    it "routes POST /reset_password to the users/passwords controller" do
      expect(post: "/reset_password").to route_to(controller: "users/passwords", action: "create")
    end

    it "routes GET /edit_password to the users/passwords controller" do
      expect(get: "/edit_password").to route_to(controller: "users/passwords", action: "edit")
    end

    it "routes PATCH /edit_password to the users/passwords controller" do
      expect(patch: "/edit_password").to route_to(controller: "users/passwords", action: "update")
    end
  end

  describe "registration routes" do
    it "routes GET /sign_up to the users/registrations controller" do
      expect(get: "/sign_up").to route_to(controller: "users/registrations", action: "new")
    end

    it "routes POST /sign_up to the users/registrations controller" do
      expect(post: "/sign_up").to route_to(controller: "users/registrations", action: "create")
    end

    it "routes GET /close_account to the users/registrations controller" do
      expect(get: "/close_account").to route_to(controller: "users/registrations", action: "cancel")
    end

    it "routes DELETE /close_account to the users/registrations controller" do
      expect(delete: "/close_account").to route_to(controller: "users/registrations", action: "destroy")
    end

    it "routes GET /edit_profile to the users/registrations controller" do
      expect(get: "/edit_profile").to route_to(controller: "users/registrations", action: "edit")
    end

    it "routes PATCH /edit_profile to the users/registrations controller" do
      expect(patch: "/edit_profile").to route_to(controller: "users/registrations", action: "update")
    end
  end
end
