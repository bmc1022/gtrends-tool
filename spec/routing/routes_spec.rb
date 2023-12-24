# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Routing", type: :routing) do
  describe "admin namespace" do
    it "routes GET admin/dashboard to admin/dashboard#dashboard" do
      expect(get: "admin/dashboard").to route_to(controller: "admin/dashboard", action: "dashboard")
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
