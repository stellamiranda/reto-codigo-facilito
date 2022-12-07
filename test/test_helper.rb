ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

Capybara.configure do |config|
  # This allows helpers like click_on to locate
  # any object by data-testid in addition to
  # built-in selector-like values
  config.test_id = "data-testid"
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Add more helper methods to be used by all tests here...
end
