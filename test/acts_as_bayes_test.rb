require_relative 'test_helper'

class TestActsAsBayesTest < MiniTest::Unit::TestCase
  def setup
    #Foo.destroy_all
  end

  def test_common_words
     klass = Foo.class_eval do
       acts_as_bayes :on=>:title
       self
     end
     assert klass::COMMON_WORDS.size > 0
  end
  def test_foo
    assert Foo.new
  end
  def test_class_method
    assert Foo.respond_to?(:acts_as_bayes), true
  end
  def test_defaults
    klass = Foo.class_eval do
      acts_as_bayes :on=>:title
      self
    end
    assert ! klass.nil?
  end
end
