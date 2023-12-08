# frozen_string_literal: true

require "simplecov"
SimpleCov.start("rails") do
  coverage_dir "reports/coverage"
  minimum_coverage 90 # Set the minimum coverage percentage
end

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
require "view_component/test_helpers"
require "view_component/system_test_helpers"
require "webmock/rspec"
require "capybara/rspec"
require "capybara/cuprite"
require "vcr"
require "sidekiq/testing"
require "pundit/rspec"
require "rspec/collection_matchers"
require "test_prof/recipes/rspec/before_all"

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit(1)
end

RSpec.configure do |config|
  config.fixture_path = Rails.root.join("spec/fixtures")
  config.use_transactional_fixtures = true

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  config.filter_gems_from_backtrace("capybara", "cuprite", "ferrum")

  # Enable in-memory caching for tests tagged with the :with_caching metadata option.
  config.include(CacheHelper)
  config.around(:each, :with_caching) { |example| with_caching(&example) }
  config.include(CaptureStdout)

  config.include(ActiveJob::TestHelper)
  config.include(FactoryBot::Syntax::Methods)
  config.include(Shoulda::Callback::Matchers::ActiveModel)

  # Component test preferences:
  config.include(ViewComponent::TestHelpers, type: :component)
  config.include(ViewComponent::SystemTestHelpers, type: :component)
  config.include(Capybara::RSpecMatchers, type: :component)
  config.include(Devise::Test::ControllerHelpers, type: :component)
  config.before(:each, type: :component) { @request = vc_test_controller.request }

  # System test preferences:
  config.before(:each, type: :system) do
    driven_by(:cuprite,
      screen_size: [1200, 800],
      options: {
        js_errors: true,
        process_timeout: 10,
        timeout: 10,
        inspector: true,
        browser_options: {}
      })
  end
  config.after(:each, type: :system) { Sidekiq::Worker.clear_all }

  [:system, :request].each do |type|
    config.include(Capybara::RSpecMatchers, type:)
    config.include(Devise::Test::IntegrationHelpers, type:)
    config.include(Warden::Test::Helpers, type:)
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework(:rspec)
    with.library(:rails)
  end
end

Capybara.default_max_wait_time = 5

VCR.configure do |config|
  config.cassette_library_dir = "spec/support/vcr_cassettes"
  config.hook_into(:webmock)
  config.ignore_localhost = true
  config.allow_http_connections_when_no_cassette = false
  config.configure_rspec_metadata!
  config.default_cassette_options = {
    record: :new_episodes,
    re_record_interval: 2_592_000 # 1 month
  }
end

Sidekiq::Testing.fake!
