require 'spec_helper'

module Pipeable
  describe Pipeable do
    let(:value) { 1 }
    let(:callable) { :puts }
    let(:caller) { nil }
    
    subject do
      described_class.new(value, caller: caller)
    end

    describe "sending messages only caller responds to" do
      it "should be able to invoke methods on caller" do
        expect(TestClass.new.pipe(3)).to eq 16
      end
    end
    
    describe "#|" do
      shared_examples_for :returns_a_pipeable do
        it "returns a Pipeable" do
          output = subject | callable
          expect(output).to be_a Pipeable
        end
      end

      describe "if a symbol" do
        let(:callable) { :foo }
        # for expedience, I'll just add a method I expect to get called
        class Pipeable
          def foo(*args); args.length; end
        end
        let(:caller) { Pipeable.new(nil) }

        it "sends argument as message with initialized value" do
          expect((subject | callable).value).to eq(1)
        end

        it_behaves_like :returns_a_pipeable
      end

      describe "if a Proc" do
        let(:callable) { ->(x) { x+1 } }

        it "calls the Proc with initialized value" do
          expect((subject | callable).value).to eq(callable.call(value))
        end

        it_behaves_like :returns_a_pipeable
      end

      describe "if a Method" do
        let(:callable) { :String }

        it "calls the Method with initialized value" do
          expect((subject | callable).value).to eq(String(value))
        end
      end

      describe "if not callable" do
        let(:callable) { 34 }

        it "raises an ArgumentError" do
          expect { subject | callable }.
            to raise_error(ArgumentError, "'#{callable}' is not callable!")
        end
      end

      describe "chaining things together" do
        let(:value) { [false, 2, :whoa] }
        let(:one) { ->(x) { x[-2] } }
        let(:two) { ->(x) { x*2 } }

        it "can chain multiple things together" do
          expect((subject | one | two | ->(x) { x-1 } | method(:String)).value).
            to eq("3")
        end
      end
    end
  end
end

class TestClass
  include Pipeable
  
  def add_one(x)
    x + 1
  end

  def square(x)
    x ** 2
  end
  
  def pipe(y)
    result = Pipeable(y) | :add_one | :square
    result.value
  end
end
