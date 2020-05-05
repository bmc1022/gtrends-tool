source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails',               '5.2.0'
gem 'pg',                  '>= 1.1.4'      # use postgresql as the database
gem 'puma',                '~> 3.11'       # use puma as the app server
gem 'bootsnap',            '~> 1.3.1'      # boot ruby/rails apps faster
gem 'turbolinks',          '>= 5.0.1'      # makes navigating faster
gem 'autoprefixer-rails',  '~> 6.7.7.1'    # add vendor prefixes to css rules
gem 'slim-rails',          '~> 3.1.2'      # provides generator required to use slim
gem 'sassc-rails',         '~> 2.1.0'      # use scss for stylesheets
gem 'uglifier',            '>= 3.1.13'     # javascript compression
gem 'jbuilder',            '~> 2.6.3'      # build json apis with ease
gem 'http',                '~> 4.4.1'      # http client
gem 'pagy',                '~> 3.8'        # pagination

group :development, :test do
  gem 'byebug', platform: :mri             # standard ruby debugger
  gem 'pry-rails'                          # use pry as the rails console
  gem 'pry-byebug'                         # adds step, next, continue commands to pry
  gem 'minitest-reporters'                 # customizable minitest output formats
  gem 'capybara'                           # acceptance test framework
  gem 'selenium-webdriver'                 # web browser automation
  gem 'mocha'                              # library for mocking and stubbing
  gem 'factory_bot_rails'                  # fixtures replacement
end

group :development do
  gem 'web-console'                        # use <%= console %> in views to access a console
  gem 'listen'                             # notifies about file modifications
  gem 'better_errors'                      # provides a better error page
  gem 'binding_of_caller'                  # retrieve the binding of a method's caller
  gem 'awesome_print', require: 'ap'       # pretty print ruby objects
end