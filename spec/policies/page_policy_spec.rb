# frozen_string_literal: true

require "rails_helper"

RSpec.describe(PagePolicy, type: :policy) do
  subject { described_class.new(user, :page) }
end
