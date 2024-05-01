# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Routing", type: :routing) do
  describe "root route" do
    it "routes GET / to gtrends#index" do
      expect(get: "/").to route_to(controller: "gtrends", action: "index")
    end
  end

  # The Sidekiq UI routes are being skipped due to limitations in handling middleware (Warden) in
  # routing specs. There is a request spec which covers these conditional routes at:
  # spec/requests/sidekiq_ui_request_spec.rb.

  describe "gtrends resource routes" do
    it "routes GET /gtrends/:id to gtrends#create" do
      expect(get: "/").to route_to(controller: "gtrends", action: "create")
    end

    it "routes DELETE /gtrends/:id to gtrends#destroy" do
      expect(delete: "/1").to route_to(controller: "gtrends", action: "destroy", id: "1")
    end
  end
end
