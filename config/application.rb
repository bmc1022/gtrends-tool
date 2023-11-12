# frozen_string_literal: true

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GtrendsTool
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(7.0)

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Use Sidekiq as the queuing backend for Active Job.
    config.active_job.queue_adapter = :sidekiq

    # Generator configuration.
    config.generators do |generator|
      generator.assets = false # Skip generating asset files.
      generator.test_framework(:rspec)
      generator.fixture_replacement(:factory_bot, dir: "spec/factories")
    end
  end
end
