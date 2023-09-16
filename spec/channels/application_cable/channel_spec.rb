# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationCable::Channel, type: :channel) do
  subject(:channel) { described_class.new(connection, {}) }

  let(:connection) { ApplicationCable::Connection.new(ActionCable.server, {}) }

  it "successfully initializes" do
    expect(channel).to be_an_instance_of(described_class)
  end
end
