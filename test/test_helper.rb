require 'minitest/unit'
require './lib/acts_as_bayes'
class Foo
  include Mongoid::Document
  include ActsAsBayes
end
