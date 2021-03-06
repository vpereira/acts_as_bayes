require_relative 'common_words'

module MapReduce

  #TO RUN IT WE WOULD NEED:
  #map = MapReduce::word_count("title")
  #reduce = MapReduce::word_count_reduce
  #to generate inline results
  #MyModel.map_reduce(map,reduce).out(inline:1)
  #to update one object
  #x = MyModel.where(:_id=>id).map_reduce(map, reduce).out(inline:1)
  #Hash[x.collect { |x,y| [x["_id"],x["value"]["count"]] } ]
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
        common_words = new Array(#{common_words.map(&:inspect).join(',')});
        var words = #{tokenize_str};
        if(words == null)
          return;
        //loop every word in the document 
        for(var i = 0; i < words.length; i++)
        {
          //check if its a common word
          if(common_words.indexOf(words[i]) == -1)
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
