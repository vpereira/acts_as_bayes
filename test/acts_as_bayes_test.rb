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
    assert klass.new.respond_to?(:threshold)
    #assert klass.new.threshold,1.5
  end
  def test_acts_as_bayes_with_params_I
    klass = Foo.instance_eval do
      acts_as_bayes :threshold=>1.0,:on=>:title
      self
    end
    assert ! klass.nil?
    assert klass.new.class, Foo
    k = klass.new(:title=>"my super foo is sexy")
    assert ! k.threshold.nil?
    assert k.threshold, 1.0
    assert k.save
  end
end
