# frozen_string_literal: true

RSpec.shared_examples("factory") do |factory, traits = nil|
  describe "#{factory} factory" do
    it "builds a valid #{factory}" do
      built_factory = build(factory, *traits)
      expect(built_factory).to be_valid
    end

    it "saves a built #{factory}" do
      built_factory = build(factory, *traits)
      expect { built_factory.save! }.to change(described_class, :count)
    end

    it "creates a valid #{factory}" do
      expect { create(factory, *traits) }.to change(described_class, :count)
    end

    it "stubs a valid #{factory}" do
      stubbed_factory = build_stubbed(factory, *traits)
      expect(stubbed_factory).to be_valid
    end
  end
end
