require_relative 'test_helper'


#TODO
#write unit tests with RhinoUnit or something similiar 
#to the code used by the acts_as_bayes/map_reduce js
class TestMapReduceFunctions < MiniTest::Should::TestCase
  setup do 
    @klass = Foo.instance_eval do
      acts_as_bayes :on=>:title, :wc_mr=>true
    end

    it "should respond to word_count" do
      assert @klass.respond_to?(:word_count)
    end

    it "should respond to word_count_reduce" do
      assert @klass.respond_to?(:word_count_reduce)
    end
   end

end
