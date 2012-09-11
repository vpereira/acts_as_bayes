require 'minitest/unit'
require 'minitest/autorun'

require './lib/acts_as_bayes'

#STOLEN FROM MONGOID
#thanks guys :-)
# These environment variables can be set if wanting to test against a database
# that is not on the local machine.
ENV["MONGOID_SPEC_HOST"] ||= "localhost"
ENV["MONGOID_SPEC_PORT"] ||= "27017"
#
# These are used when creating any connection in the test suite.
HOST = ENV["MONGOID_SPEC_HOST"]
PORT = ENV["MONGOID_SPEC_PORT"].to_i
#
# Moped.logger.level = Logger::DEBUG
# Mongoid.logger.level = Logger::DEBUG
#
# When testing locally we use the database named mongoid_test. However when
# tests are running in parallel on Travis we need to use different database
# names for each process running since we do not have transactions and want a
# clean slate before each spec run.
def database_id
   ENV["CI"] ? "mongoid_#{Process.pid}" : "mongoid_test"
end

# Can we connect to MongoHQ from this box?
def mongohq_connectable?
   ENV["MONGOHQ_REPL_PASS"].present?
end
# Set the database that the spec suite connects to.
Mongoid.configure do |config|
     config.connect_to database_id
end

class Foo
  include Mongoid::Document
  include ActsAsBayes
  field :title, :type=>String
end
