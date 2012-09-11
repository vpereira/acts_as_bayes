require "bundler/setup"
require "mongoid"

require "acts_as_bayes/version"

module ActsAsBayes
  def self.included(base)
      base.extend ClassMethods
      base.send :attr_accessor, :threshold
  end
  module InstanceMethods
  end
  module ClassMethods
    #usage:
    # hash as parameter or/and block
    def acts_as_bayes(opts = {},&block)
      send :include, InstanceMethods
      opts.merge!({:field=>:rank,:threshold=>1.5})
      yield(opts) if block_given?
      instance_eval <<-EOC
        field :field=>"#{opts[:field]}".to_sym,:type=>Float
      EOC
      class_eval <<-EOF
        def threshold
          #{opts[:threshold]}
        end
      EOF
    end
  end
end
