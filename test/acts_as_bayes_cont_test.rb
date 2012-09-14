require_relative 'test_helper'
class TestWithCustomParams < MiniTest::Should::TestCase

  setup do
    @klass = Foo.class_eval do
      acts_as_bayes :field=>:words, :on=>:title, :threshold=>0.5
      self
    end
  end
  should "not be nil" do
    assert ! @klass.nil?
  end

  should "be a Foo" do
   assert @klass.new.class == Foo
  end

  should "respond to threshold" do
    assert @klass.respond_to?(:threshold)
  end
  should "have a custom threshold" do
    #assert @klass.threshold == 0.5
  end
end
