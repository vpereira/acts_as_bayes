require_relative 'test_helper'

class ActsAsBayesTest < MiniTest::Unit::TestCase
  def test_foo
    assert Foo.new
  end
  
  def test_class_method
    assert Foo.respond_to?(:acts_as_bayes), true
  end
  
  def test_defaults
    klass = Foo.instance_eval do
      acts_as_bayes
    end
    assert ! klass.nil?
  end
  
  def test_acts_as_bayes_with_params_I
    klass = Foo.instance_eval do
      acts_as_bayes :threshold=>1.0
    end
    assert ! klass.nil?
  end
  
  def test_acts_as_bayes_with_params_I
    klass = Foo.instance_eval do
      acts_as_bayes do |a|
        a.threshold = 1.0
      end
    end
    assert ! klass.nil?
  end
end 

