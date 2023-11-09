# frozen_string_literal: true

RSpec.shared_examples("rolify") do |model_factory|
  describe "roles" do
    let(:resource) { create(model_factory)       }
    let(:role)     { create(:role, name: "test") }

    before { resource.roles.delete_all }

    it { is_expected.to have_and_belong_to_many(:roles) }

    it "can have roles" do
      resource.add_role(role.name)
      expect(resource.has_role?(role.name)).to be(true)
    end

    it "can remove roles" do
      resource.add_role(role.name)
      resource.remove_role(role.name)
      expect(resource.has_role?(role.name)).to be(false)
    end
  end
end
