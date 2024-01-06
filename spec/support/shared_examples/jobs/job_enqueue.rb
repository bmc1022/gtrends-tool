# frozen_string_literal: true

RSpec.shared_examples("job enqueuing") do
  describe "job enqueuing" do
    it "successfully enqueues #{described_class}" do
      expect {
        described_class.perform_later(*@job_arguments)
      }.to have_enqueued_job(described_class).with(*@job_arguments)
    end
  end
end
