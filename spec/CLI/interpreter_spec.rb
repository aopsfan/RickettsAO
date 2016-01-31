require_relative '../spec_helper'

class FooCommandCenter
  attr_accessor :bar_string, :bar_num, :bar_bool, :option_1, :option_bar
  
  def reset
    @bar_string = nil
    @bar_num = nil
    @bar_bool = nil
    @option_1 = nil
    @option_bar = nil
  end
  
  def foo(bar_string, bar_num, bar_bool, options)
    @bar_string = bar_string
    @bar_num = bar_num
    @bar_bool = bar_bool
    @option_1 = options[1]
    @option_bar = options[:bar]
  end
end

describe Interpreter do  
  before :each do
    @interpreter = Interpreter.new
    @command_center = FooCommandCenter.new
    @interpreter.delegate = @command_center
  end
  
  describe "#execute" do
    context "when line is \"foo 'bar' !bar 1.234 true 1=one\"" do
      before :each do
        @command_center.reset
        @interpreter.execute("foo 'bar' !bar 1.234 true 1=one")
      end
      
      it "interprets the first argument as 'bar'" do
        expect(@command_center.bar_string).to eql('bar')
      end
      
      it "interprets the second argument as 1.234" do
        expect(@command_center.bar_num).to eql(1.234)
      end
      
      it "interprets the third argument as true" do
        expect(@command_center.bar_bool).to be_truthy
      end
      
      it "interprets option 1 as one" do
        expect(@command_center.option_1).to eql(:one)
      end
      
      it "interprets option :bar as false" do
        expect(@command_center.option_bar).to be_falsey
      end
    end
  end
end