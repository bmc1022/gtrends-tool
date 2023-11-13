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
end
