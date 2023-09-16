# frozen_string_literal: true

require "rails_helper"

RSpec.describe(Role, type: :model) do
  subject(:role) { build(:role) }

  include_examples "factory", :role

  describe "attributes and indexes" do
    # Database columns
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:resource_type).of_type(:string) }
    it { is_expected.to have_db_column(:resource_id).of_type(:integer) }

    # Database indexes
    it { is_expected.to have_db_index([:name, :resource_type, :resource_id]) }
    it { is_expected.to have_db_index([:resource_type, :resource_id]) }
  end

  describe "associations" do
    it { is_expected.to have_and_belong_to_many(:users).join_table(:users_roles) }
    it { is_expected.to belong_to(:resource).optional }
  end

  describe "validations" do
    it { is_expected.to validate_inclusion_of(:resource_type)
                        .in_array(Rolify.resource_types).allow_nil }
  end
end
