# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationService, type: :service) do
  describe ".call" do
    let(:test_service_class) do
      Class.new(ApplicationService) do
        class_attribute :called

        def initialize(*args)
          super()
          @args = args
        end

        def call
          self.class.called = true
        end
      end
    end

    before do
      stub_const("TestService", test_service_class)
      allow(TestService).to receive(:new).and_call_original
    end

    it "calls the instance method #call on a new instance of the service" do
      expect { TestService.call }.to change(TestService, :called).from(nil).to(true)
    end

    it "passes arguments from .call to .new" do
      args = [1, "arg2", :arg_3]
      TestService.call(*args)
      expect(TestService).to have_received(:new).with(*args)
    end
  end
end
