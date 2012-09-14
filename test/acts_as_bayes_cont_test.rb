require_relative 'test_helper'
class TestWithCustomParams < MiniTest::Should::TestCase

  setup do
    @klass = Foo.class_eval do
      acts_as_bayes :field=>:words, :on=>:title, :threshold=>0.5
      self
    end
  end
  context "Class Methods" do
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
      assert @klass.threshold == 0.5
    end
  end
  context "Instance Methods" do
    should "not be nil" do
      assert ! @klass.new.nil?
    end
    should "respond to title" do
      assert @klass.new.respond_to?(:title)
    end
    should "respond to words" do
      assert @klass.new.respond_to?(:words)
    end
  end
end
