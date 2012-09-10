require "bundler/setup"
require "mongoid"

require "acts_as_bayes/version"

module ActsAsBayes
  def self.included(base)
      base.send :extend, ClassMethods
  end
  module InstanceMethods
    
  end
  module ClassMethods
    #usage:
    # hash as parameter or/and block
    def acts_as_bayes(opts = {})
      send :include, InstanceMethods
      opts.merge!({:field=>"rank",:threshold=>1.5})
      yield if block_given?
    end
  end
end
