# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Routing", type: :routing) do
  describe "authentication routes" do
    it "routes GET /login to the sessions controller" do
      expect(get: "/login").to route_to(controller: "sessions", action: "new")
    end

    it "routes POST /login to the sessions controller" do
      expect(post: "/login").to route_to(controller: "sessions", action: "create")
    end

    it "routes DELETE /logout to the sessions controller" do
      expect(delete: "/logout").to route_to(controller: "sessions", action: "destroy")
    end
  end

  describe "gtrends routes" do
    it "routes GET / to the gtrends controller" do
      expect(get: "/").to route_to(controller: "gtrends", action: "index")
    end

    it "routes POST / to the gtrends controller" do
      expect(post: "/").to route_to(controller: "gtrends", action: "create")
    end

    it "routes DELETE /:id to the gtrends controller" do
      expect(delete: "/1").to route_to(controller: "gtrends", action: "destroy", id: "1")
    end
  end
end
