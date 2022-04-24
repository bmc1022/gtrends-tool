source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

gem 'rails',               '~> 7.0.2'
gem 'pg',                  '>= 1.3.1'                  # use postgresql as the database
gem 'puma',                '~> 5.6.2'                  # use puma as the app server
gem 'bootsnap', require: false                         # boot ruby/rails apps faster
gem "sprockets-rails"                                  # asset pipeline
gem "jsbundling-rails"                                 # bundle and transpile javascript
gem 'turbo-rails'                                      # spa-like page accelerator
gem 'stimulus-rails'                                   # a modest javascript framework
gem 'redis',               '~> 4.6.0'                  # use redis adapter to run action cable in production
gem 'jbuilder',            '~> 2.11.5'                 # build json apis with ease
gem 'slim-rails',          '~> 3.3.0'                  # compile slim to html
gem 'sassc-rails',         '~> 2.1.2'                  # compile scss to css
gem 'devise',              '~> 4.8.1'                  # authentication
gem 'http',                '~> 5.0.4'                  # http client
gem 'pagy',                '~> 5.10.1'                 # pagination

group :development, :test do
  gem 'debug', platforms: %i[ mri mingw x64_mingw ]    # standard ruby debugger
  gem 'pry-rails'                                      # use pry as the rails console
  gem 'rspec-rails'                                    # use rspec testing framework
  gem 'capybara'                                       # acceptance test framework
  gem 'selenium-webdriver'                             # web browser automation
  gem 'webdrivers'                                     # mimic the behavior of actual users
  gem 'factory_bot_rails'                              # fixtures replacement
  gem 'rubocop', require: false                        # enforces ruby style conventions
  gem 'rubocop-performance'                            # rubocop performance rules
  gem 'rubocop-rails'                                  # rubocop rails rules
  gem 'rubocop-rspec'                                  # rubocop rspec rules
end

group :development do
  gem 'web-console'                                    # use <%= console %> in views to access a console
  gem 'listen'                                         # notifies about file modifications
  gem "better_errors"                                  # replaces standard rails error page
  gem "binding_of_caller"                              # extends better_errors (repl/variable inspection)
  gem 'awesome_print', require: 'ap'                   # pretty print ruby objects
  gem 'guard-rspec', require: false                    # automatically run specs when files are modified
  gem 'guard-rubocop'                                  # automatically run rubocop when files are modified
  gem 'stackprof', require: false                      # sampling call-stack profiler for ruby
  gem 'memory_profiler'                                # memory profiler for ruby
  gem 'rack-mini-profiler'                             # profile page speed, db queries, memory usage, etc
  gem 'bullet'                                         # identifies n+1 queries and unused eager loading
  gem 'derailed_benchmarks'                            # output the memory use of gems
  gem 'brakeman'                                       # checks for security vulnerabilities
end

group :test do
  gem 'simplecov', require: false                      # code coverage analysis tool for ruby
  gem 'rspec-collection_matchers'                      # collection matchers (e.g. have(n).items)
  gem 'shoulda'                                        # one-liners to test common rails functionality
  gem 'shoulda-callback-matchers'                      # shoulda matchers to test callbacks
  gem 'test-prof'                                      # analyze test suite performance
end
