require File.dirname(__FILE__) + '/../../spec_helper'
require File.dirname(__FILE__) + '/fixtures/classes.rb'

describe "String#replace" do
  it "replaces the content of self with other and returns self" do
    a = "some string"
    a.replace("another string").should equal(a)
    a.should == "another string"
  end
  
  it "replaces the taint status of self with that of other" do
    a = "an untainted string"
    b = "a tainted string".taint
    a.replace(b)
    a.tainted?.should == true
  end
  
  it "tries to convert other to string using to_str" do
    other = mock('x')
    other.should_receive(:to_str).and_return("converted to a string")
    "hello".replace(other).should == "converted to a string"
  end
  
  it "raises a TypeError if other can't be converted to string" do
    lambda { "hello".replace(123)       }.should raise_error(TypeError)
    lambda { "hello".replace(:test)     }.should raise_error(TypeError)
    lambda { "hello".replace(mock('x')) }.should raise_error(TypeError)
  end
  
  compliant_on :ruby, :jruby do
    it "raises a TypeError if self is frozen" do
      a = "hello".freeze

      a.replace(a) # ok, no change
      lambda { a.replace("")      }.should raise_error(TypeError)
      lambda { a.replace("world") }.should raise_error(TypeError)
    end
  end
end
