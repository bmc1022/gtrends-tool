# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationCable::Connection, type: :channel) do
  subject(:connection) { described_class.new(ActionCable.server, {}) }

  it "successfully initializes" do
    expect(connection).to be_an_instance_of(described_class)
  end
end
