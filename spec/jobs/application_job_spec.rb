# frozen_string_literal: true

require "rails_helper"

RSpec.describe(ApplicationJob, type: :job) do
  include ActiveJob::TestHelper

  before { stub_const("TestJob", Class.new(described_class)) }
  after  { clear_enqueued_jobs }

  let(:record) { create(:user) }

  describe "discard_on ActiveJob::DeserializationError" do
    it "discards the job when a deserialization error occurs" do
      # DeserializationErrors are caught and handled within the job's execution context, and not
      # bubbled up to the testing context, so we can't directly test that the error occurred.
      # Toggling the option off will cause the test to fail due to a DeserializationError however.

      TestJob.perform_later(record)
      expect(enqueued_jobs.size).to eq(1)

      record.destroy!

      expect { perform_enqueued_jobs }.to change(enqueued_jobs, :size).by(-1)
    end
  end
end
