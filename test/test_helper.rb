require 'minitest/autorun'
require 'minitest/pride'

# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

def setup_database
  ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS users")
  ActiveRecord::Base.connection.execute("CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT)")

  ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS comments")
  ActiveRecord::Base.connection.execute("CREATE TABLE comments (id INTEGER PRIMARY KEY, body TEXT, user_id INTEGER)")
end

# Load fixtures from the engine
if ActiveSupport::TestCase.method_defined?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
end
