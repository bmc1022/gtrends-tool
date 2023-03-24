# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Keyword, type: :model) do
  let(:keyword) { build_stubbed(:keyword) }

  include_examples "factory", :keyword
end
