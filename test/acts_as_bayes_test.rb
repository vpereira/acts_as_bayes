require_relative 'test_helper'

class TestActsAsBayesTest < MiniTest::Unit::TestCase
  def test_foo
    assert Foo.new
  end
  
  def test_class_method
    assert Foo.respond_to?(:acts_as_bayes), true
  end
  
  def test_defaults
    klass = Foo.class_eval do
      acts_as_bayes
      self
    end
    assert ! klass.nil?
    assert klass.new.respond_to?(:threshold)
    #assert klass.new.threshold,1.5
  end
  
  def test_acts_as_bayes_with_params_I
    klass = Foo.class_eval do
      acts_as_bayes :threshold=>1.0
      self
    end
    assert ! klass.nil?
  #  assert klass.threshold,1.0
  end
  
  #def test_acts_as_bayes_with_params_I
  #  klass = Foo.class_eval do
  #    acts_as_bayes do |a|
  #      a.threshold = 1.0
  #    end
  #    self
  #  end
  #  assert ! klass.nil?
  #  assert klass.threshold,1.0    
  #end
end 