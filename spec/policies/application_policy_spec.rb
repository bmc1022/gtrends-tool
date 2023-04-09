# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationPolicy, type: :policy) do
  subject(:application_policy) { described_class.new(user, record) }

  let(:user)   { build(:user)            }
  let(:record) { instance_double(Gtrend) }

  describe "default permissions" do
    it { is_expected.to forbid_all_actions }
  end

  describe ApplicationPolicy::Scope do
    subject(:scope)  { described_class.new(user, base_scope) }

    let(:base_scope) { class_double(Gtrend) }

    describe "#resolve" do
      it "raises a NotImplementedError" do
        expect { scope.resolve }.to raise_error(NotImplementedError, /You must define #resolve/)
      end
    end
  end
end
