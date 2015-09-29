ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'database_cleaner'

DatabaseCleaner.strategy = :transaction

class ActiveSupport::TestCase
  fixtures :all

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
