require_relative 'test_helper'

class TestBayesCategory < MiniTest::Should::TestCase
  setup do
    BayesCategory.destroy_all
    @b = BayesCategory.new(:category=>"foo")
  end

  should "not be nil" do
    assert ! @b.nil?
  end

  should "be able to update the words" do
    @b.words =  { "foo"=>10, "bar"=>20 }
    @b.save
    assert @b.word_count > 0
    assert @b.word_count == 30
  end

  should "sum_count" do
    assert @b.sum_count("foo",10)
    @b.words["foo"] == 20
  end
 
end
