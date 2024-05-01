# frozen_string_literal: true

require "rails_helper"

RSpec.describe("Routing", type: :routing) do
  # The Sidekiq UI routes are being skipped due to limitations in handling middleware (Warden) in
  # routing specs. There is a request spec which covers these conditional routes at:
  # spec/requests/sidekiq_ui_request_spec.rb.

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
