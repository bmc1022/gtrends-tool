# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationMailer, type: :mailer) do
  describe "defaults" do
    it "has the correct default from address" do
      expect(described_class.default[:from]).to eq("from@example.com")
    end

    it "has the correct default layout" do
      expect(described_class._layout).to eq("mailer")
    end
  end
end
