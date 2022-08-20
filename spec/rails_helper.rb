# frozen_string_literal: true

require "simplecov"
SimpleCov.start("rails") { coverage_dir "reports/coverage" }

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "rspec/rails"
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

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework(:rspec)
    with.library(:rails)
  end
end

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  config.include(FactoryBot::Syntax::Methods)
  config.include(Shoulda::Callback::Matchers::ActiveModel)

  config.include(Devise::Test::IntegrationHelpers, type: :system)
  config.include(Warden::Test::Helpers)

  # Driver setup for system tests.
  config.before(:each, type: :system) { driven_by :selenium_chrome_headless }
end
