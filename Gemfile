# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

gem "rails",             "~> 7.0.2"                    # Web app framework.
gem "pg",                ">= 1.3.1"                    # Use PostgreSQL as the database.
gem "redis",             "~> 5.0.6"                    # Use Redis adapter to run ActionCable in production.
gem "cable_ready",       "5.0.0.rc2"                   # Trigger client-side DOM changes from server-side Ruby.
gem "puma",              "~> 5.6.2"                    # Use Puma as the app server.
gem "bootsnap",          "~> 1.12.0", require: false   # Boot Ruby/Rails apps faster.
gem "sprockets-rails",   "~> 3.4.2"                    # Asset Pipeline.
gem "jsbundling-rails",  "~> 1.0.2"                    # Bundle and transpile JavaScript.
gem "cssbundling-rails", "~> 1.1.1"                    # Bundle and process CSS.
gem "jbuilder",          "~> 2.11.5"                   # Build JSON APIs with ease.
gem "slim-rails",        "~> 3.3.0"                    # Compile Slim to HTML.
gem "devise",            "~> 4.8.1"                    # Authentication.
gem "pundit",            "~> 2.3.0"                    # Authorization.
gem "sidekiq",           "~> 7.0.8"                    # Background job processing.
gem "whenever",          "~> 1.0.0", require: false    # Cron jobs in Ruby.
gem "http",              "~> 5.0.4"                    # HTTP client.
gem "pagy",              "~> 5.10.1"                   # Pagination.

group :development, :test do
  gem "debug", platforms: [:mri, :mingw, :x64_mingw]   # Standard Ruby debugger.
  gem "debase", require: false                         # Fast implementation of the standard debugger.
  gem "ruby-debug-ide", require: false                 # An interface between ruby-debug and IDEs.
  gem "solargraph", require: false                     # Code analysis and autocompletion.
  gem "pry-rails"                                      # Use Pry as the Rails console.
  gem "rspec-rails"                                    # Use RSpec testing framework.
  gem "capybara"                                       # Acceptance test framework.
  gem "selenium-webdriver"                             # Web browser automation.
  gem "webdrivers"                                     # Mimic the behavior of actual users.
  gem "factory_bot_rails"                              # Fixtures replacement.
  gem "rubocop", require: false                        # Enforces Ruby style conventions.
  gem "rubocop-performance"                            # RuboCop performance rules.
  gem "rubocop-rails"                                  # RuboCop Rails rules.
  gem "rubocop-rspec"                                  # RuboCop RSpec rules.
end

group :development do
  gem "web-console"                                    # Use <%= console %> in views to access a console.
  gem "listen"                                         # Notifies about file modifications.
  gem "better_errors"                                  # Replaces standard Rails error page.
  gem "binding_of_caller"                              # Extends better_errors (repl/variable inspection).
  gem "awesome_print", require: "ap"                   # Pretty print Ruby objects.
  gem "lefthook"                                       # Git hooks manager for Ruby and Node.js.
  gem "guard-rspec", require: false                    # Automatically run specs when files are modified.
  gem "guard-rubocop"                                  # Automatically run RuboCop when files are modified.
  gem "rails_best_practices"                           # Code quality metrics.
  gem "reek"                                           # Code smell detector.
  gem "brakeman"                                       # Checks for security vulnerabilities.
  gem "stackprof", require: false                      # Sampling call-stack profiler for Ruby.
  gem "memory_profiler"                                # Memory profiler for Ruby.
  gem "rack-mini-profiler"                             # Profile page speed, DB queries, memory usage, etc.
  gem "bullet"                                         # Identifies n+1 queries and unused eager loading.
  gem "derailed_benchmarks"                            # Output the memory use of Gems.
end

group :test do
  gem "simplecov", require: false                      # Code coverage analysis tool for Ruby.
  gem "webmock"                                        # Stub and set expectations on HTTP requests in Ruby.
  gem "vcr"                                            # Record HTTP interactions and replay them during future test runs.
  gem "rspec-collection_matchers"                      # Collection matchers (e.g. have(n).items).
  gem "shoulda-matchers"                               # One-liners to test common Rails functionality.
  gem "shoulda-callback-matchers"                      # Shoulda matchers to test callbacks.
  gem "pundit-matchers"                                # RSpec matchers for testing Pundit authorisation policies.
  gem "test-prof"                                      # Analyze test suite performance.
end
