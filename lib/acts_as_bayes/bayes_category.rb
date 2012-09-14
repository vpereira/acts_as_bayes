class BayesCategory
  include Mongoid::Document
  field :category, :type=>String
  field :words, :type=>Hash, :default=>{}
  field :word_count, :type=>Integer, :default=>0
  field :num_docs, :type=>Integer, :default=>0
  before_save :update_word_count

  index num_docs:1
  index word_count:1

  def word_probability(word)
    words[word.stem].to_f + 1 / self.word_count.to_f
  end

  #words is a hash "word"=>count
  def words_update(wordz)
    wordz.each do |w,c|
      self.words.has_key?(w) ? self.words[w] += c : self.words[w] = c
    end
  end

  #category probability
  #total_docs = your acts_as_bayes model total
  def probability(total_docs = 1)
    self.num_docs / total_docs.to_f
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
   self.word_count = self.words.values.inject(:+)
  end
end
