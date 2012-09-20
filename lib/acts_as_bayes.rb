require "bundler/setup"
require "mongoid"
require 'stemmer'
require "acts_as_bayes/version"
require "acts_as_bayes/common_words"
require "acts_as_bayes/bayes_category"
require "acts_as_bayes/map_reduce"

module ActsAsBayes

  def self.included(base)
      base.extend ClassMethods
      base.send :before_save, :word_count
  end

  module InstanceMethods
    #TODO
    #first MapReduce based version
    #Maybe words should be a relation and we update the relation collection using map_reduce().out(merge:collection)
    #Not Being used
    def word_count_mr
     self.words = Hash[self.class.where(:_id=>self.id).map_reduce(MapReduce::word_count("title"),MapReduce::word_count_reduce).out(inline:1).collect { |x,y| [ x["_id"],x["value"]["count"].to_i ] }]
    end

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
      best,second_best = sorted.pop, sorted.pop
      return default if second_best.nil?
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
      #TODO
      #rename those options
      #wc_mr = if you want to run the word_count with map & reduce
      #field = where in your model, you will store the words (its an array)
      #cb_off = if you want to disable the callbacks (probably to run everything async using jobs
      #threshold = threshold from bayes. everything under this threshold will be classified as "unknown"
      opts = {:wc_mr=>false,:field=>:words,:threshold=>1.5, :on=>:title,:cb_off=>false}.merge(opts)
      yield(opts) if block_given?
      instance_eval <<-EOC
        field :"#{opts[:field]}",:type=>Hash,:default=>{}
        def threshold
          #{opts[:threshold]}
        end
        def cb_off?
          #{opts[:cb_off]}
        end
        def word_count_as_map_reduce?
         #{opts[:wc_mr]}
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
    def word_count_map_reduce
     Hash[self.all.map_reduce(
       MapReduce::word_count("title"),MapReduce::word_count_reduce
     ).out(inline:1).collect { |x,y| [ x["_id"],x["value"]["count"].to_i ] }]
    end
  end
end
