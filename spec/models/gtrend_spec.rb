# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Gtrend, type: :model) do
  let(:gtrend) { build_stubbed(:gtrend) }

  include_examples "factory", :gtrend
end
