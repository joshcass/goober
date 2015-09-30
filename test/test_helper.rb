ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/pride'
require 'capybara/rails'
require 'database_cleaner'
require 'simplecov'
require 'vcr'

SimpleCov.start 'rails'

DatabaseCleaner.strategy = :transaction

VCR.configure do |c|
  c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.before_record do |r|
    r.request.headers.delete("Authorization")
  end
end

class ActiveSupport::TestCase

  def setup
    DatabaseCleaner.start
  end

  def teardown
    DatabaseCleaner.clean
  end
end
