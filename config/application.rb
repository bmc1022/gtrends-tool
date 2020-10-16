require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GtrendsTool
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Generator configuration.
    config.generators do |g| 
      g.assets = false # skip generating asset files
      g.test_framework :minitest, spec: false, fixture: false
      g.fixture_replacement :factory_bot
    end
  end
end
