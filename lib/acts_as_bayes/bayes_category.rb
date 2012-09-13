class BayesCategory
  include Mongoid::Document
  field :category, :type=>String
  field :words, :type=>Hash, :default=>{}
  field :word_count, :type=>Integer, :default=>0

  before_save :update_word_count

  def word_probability(word)
    words[word.stem].to_f + 1 / self.word_count.to_f
  end

  #warning
  #you must save it yourself
  def sum_count(word,count = 0)
    if words.has_key?word
      words[word] += count
    else
      words[word] = count
    end
  end

  private
  def update_word_count
   self.word_count = words.values.inject.inject(:+)
  end
end
