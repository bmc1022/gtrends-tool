require 'simplecov'
SimpleCov.start 'rails' do
  coverage_dir 'reports/coverage'
end

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'mocha/minitest'
require 'minitest/reporters'

Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)
  
  include FactoryBot::Syntax::Methods
  ActiveRecord::Migration.check_pending!
  
  setup do
    FactoryBot.reload # reset factory sequences
  end
  
  def reload_page
    visit current_path
  end
end
