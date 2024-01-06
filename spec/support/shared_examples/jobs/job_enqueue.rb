# frozen_string_literal: true

RSpec.shared_examples("job enqueuing") do |queue_as: :default|
  describe "job enqueuing" do
    it "successfully enqueues #{described_class}" do
      expect {
        described_class.perform_later(*@job_arguments)
      }.to have_enqueued_job(described_class).with(*@job_arguments)
    end
  end

  describe "queue as" do
    it "is enqueued in the #{queue_as} queue" do
      expect {
        described_class.perform_later(*@job_arguments)
      }.to have_enqueued_job.on_queue(queue_as)
    end
  end
end
