require "bundler/setup"
require "mongoid"
require 'stemmer'
require "acts_as_bayes/version"
require "acts_as_bayes/common_words"
require "acts_as_bayes/bayes_category"

module ActsAsBayes


  def self.included(base)
      base.extend ClassMethods
      base.send :before_save, :word_count
  end

  module InstanceMethods
    #TODO
    #maybe should we do it thru MAP & REDUCE?
    #maybe the output collection should be a relation with the base class
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

    def probability(category)
      doc_probability(category) * BayesCategory.where(:category=>category).first.probability(self.class.send(:count))
    end

    #probability method
    #doc_probability
    #probability that a document belongs to a category
    def doc_probability(category)
      doc_prob = 1.0
      self.words.each do |word|
        doc_prob *= BayesCategory.where(:category=>category).first.word_probability(word[0])
      end
      doc_prob
    end

    #get a list of probabilities that a document belongs to a category
    def probabilities
      Hash[ BayesCategory.all.to_a.collect { |word|
                [word.category, probability(word.category)]
      }]
    end

    #classify method
    def classify(default = 'unknown')
      sorted = probabilities.sort {|a,b| a[1]<=>b[1]}
      return default if sorted.empty?
      best,second_best = sorted.pop, sorted.pop
      return best[0] if best[1]/second_best[1] > self.class.threshold
      default
    end
    #train method
    def train(category)
      #implement it
      #We should update the num_of_docs
      c = BayesCategory.find_or_initialize_by(:category=>category)
      c.inc(:num_docs,1)
      c.words_update(self.words)
      c.save
    end
  end

  module ClassMethods
    #usage:
    # hash as parameter or/and block
    def acts_as_bayes(opts = {},&block)
      send :include, InstanceMethods
      opts = {:field=>:words,:threshold=>1.5, :on=>:title}.merge(opts)
      yield(opts) if block_given?
      instance_eval <<-EOC
        field :"#{opts[:field]}",:type=>Hash,:default=>{}
        def threshold
          #{opts[:threshold]}
        end
       EOC
      class_eval <<-EOF
       def words_field
         #{opts[:field]}
       end
       def field_to_calculate
         #{opts[:on]}
       end
     EOF
    end
  end
end
