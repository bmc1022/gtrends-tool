source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

gem 'rails',               '~> 7.0.2'
gem 'pg',                  '>= 1.3.1'                  # use postgresql as the database
gem 'puma',                '~> 5.6.2'                  # use puma as the app server
gem 'bootsnap', require: false                         # boot ruby/rails apps faster
gem "sprockets-rails"                                  # asset pipeline
gem "importmap-rails"                                  # use javascript with esm import maps
gem 'turbo-rails'                                      # spa-like page accelerator
gem 'stimulus-rails'                                   # a modest javascript framework
gem 'redis',               '~> 4.6.0'                  # use redis adapter to run action cable in production
gem 'jbuilder',            '~> 2.11.5'                 # build json apis with ease
gem 'slim-rails',          '~> 3.3.0'                  # compile slim to html
gem 'sassc-rails',         '~> 2.1.2'                  # compile scss to css
gem 'bootstrap',           '~> 5.1.3'                  # css/js front-end framework
gem 'devise',              '~> 4.8.1'                  # authentication
gem 'http',                '~> 5.0.4'                  # http client
gem 'pagy',                '~> 5.10.1'                 # pagination

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]  # standard ruby debugger
  gem 'pry-rails'                                      # use pry as the rails console
  gem 'pry-byebug'                                     # adds step, next, continue commands to pry
  gem 'minitest-reporters'                             # customizable minitest output formats
  gem 'capybara'                                       # acceptance test framework
  gem 'selenium-webdriver'                             # web browser automation
  gem 'webdrivers'                                     # mimic the behavior of actual users
  gem 'factory_bot_rails'                              # fixtures replacement
  gem 'mocha'                                          # library for mocking and stubbing
  gem 'rubocop', require: false                        # enforces ruby style conventions
  gem 'simplecov', require: false                      # code coverage analysis tool for ruby
  gem 'brakeman'                                       # checks for security vulnerabilities
end

group :development do
  gem 'web-console'                                    # use <%= console %> in views to access a console
  gem 'listen'                                         # notifies about file modifications
  gem 'awesome_print', require: 'ap'                   # pretty print ruby objects
  gem 'derailed'                                       # output the memory use of gems
end
