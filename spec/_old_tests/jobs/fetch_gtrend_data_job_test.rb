require "test_helper"

class FetchGtrendDataJobTest < ActiveJob::TestCase

  setup do
    @trend = create(:gtrend, kws: "one, two, three")
  end

  teardown do
    clear_enqueued_jobs
    clear_performed_jobs
  end

  test "perform job and add keywords to trend" do
    assert_equal 0, @trend.keywords.size
    assert_enqueued_with(job: FetchGtrendDataJob, queue: "default") do
      FetchGtrendDataJob.perform_later(@trend, @trend.kws)
    end
    perform_enqueued_jobs
    assert_performed_jobs 1
    assert_equal 3, @trend.reload.keywords.size
    assert_equal ["one", "two", "three"], @trend.keywords.pluck(:kw)
  end

  test "update job_status to queued after job is enqueued" do
    assert_equal "", @trend.job_status
    assert_enqueued_with(job: FetchGtrendDataJob, queue: "default") do
      FetchGtrendDataJob.perform_later(@trend, @trend.kws)
    end
    assert_enqueued_jobs 1
    assert_equal "queued", @trend.reload.job_status
  end

end
