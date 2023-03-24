# frozen_string_literal: true

require "rails_helper"

RSpec.describe(User, type: :model) do
  let(:user) { build_stubbed(:user) }

  include_examples "factory", :user
end
