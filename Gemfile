source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails',               '6.0.3'
gem 'pg',                  '>= 1.2.3'                  # use postgresql as the database
gem 'puma',                '~> 4.1'                    # use puma as the app server
gem 'bootsnap',            '>= 1.4.4', require: false  # boot ruby/rails apps faster
gem 'slim-rails',          '~> 3.2.0'                  # provides generator required to use slim
gem 'webpacker',           '~> 5.2.1'                  # transpile app-like javascript
gem 'jbuilder',            '~> 2.7'                    # build json apis with ease
gem 'http',                '~> 4.4.1'                  # http client
gem 'pagy',                '~> 3.8.3'                  # pagination

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
end
