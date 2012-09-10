require "bundler/setup"
require "mongoid"

require "acts_as_bayes/version"

module ActsAsBayes
  def self.included(base)
      base.send :extend, ClassMethods
      base.send :attr_reader, :threshold      
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
      instance_variable_set(:@threshold, 1.5)
    end
  end
end
