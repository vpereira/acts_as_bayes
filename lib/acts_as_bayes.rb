require "bundler/setup"
require "mongoid"
require 'stemmer'
require "acts_as_bayes/version"
require "acts_as_bayes/common_words"

module ActsAsBayes

  def self.included(base)
      base.extend ClassMethods
      base.send :attr_accessor, :threshold
  end

  module InstanceMethods
    def word_count
      words = field_to_calculate.gsub(/[^\w\s]/,"").split
      d = Hash.new
      words.each do |word|
         word.downcase!
         key = word.stem
         unless COMMON_WORDS.include?(word) # remove common words
           d[key] ||= 0
           d[key] += 1
         end
      end
      self.words = d
    end
  end

  module ClassMethods
    #usage:
    # hash as parameter or/and block
    def acts_as_bayes(opts = {},&block)
      send :include, InstanceMethods
      opts.merge!({:field=>:words,:threshold=>1.5,:on=>:title})
      yield(opts) if block_given?
      instance_eval <<-EOC
        field :"#{opts[:field]}",:type=>Hash,:default=>{}
        before_save :word_count

      EOC
      class_eval <<-EOF
       def field_to_calculate
         #{opts[:on]}
       end
       def threshold
          #{opts[:threshold]}
        end
      EOF
    end
  end
end
