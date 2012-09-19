require_relative 'common_words'

module MapReduce

  def self.word_count(field)
     #TODO
     #COMMON WORDS should be here
     tokenize_str = "this.#{field}.match(/\\w+/g)"
     common_words = ActsAsBayes::COMMON_WORDS
     map_f = <<-MAP
     function() {
        //TODO
        //use the field above 
        // maybe it could be multiple fields?
        var common_words = new Array(#{common_words.map(&:inspect).join(',')});
        var words = #{tokenize_str};
        if (words == null)
          return;
        //loop every word in the document 
        for(var i = 0; i < words.length; i++)
        {
            emit(words[i], { count : 1 });
        }
      }
    MAP
    map_f
  end
  def self.word_count_reduce
    reduce_f = <<-REDUCE
      function(key,values) {
       var total = 0;
       for(var i = 0; i < values.length; i++)
         total += values[i].count;
       return { count : total };
      }
    REDUCE
    reduce_f
  end
end
