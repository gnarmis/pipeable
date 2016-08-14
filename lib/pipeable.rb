Dir[File.dirname(__FILE__) + '/pipeable/*.rb'].each {|file| require file }

module Pipeable
  # Can initialize with any value and then allow you to pipe it through any
  # methods or Procs/lambdas
  # Example: Pipeable(0) | ->(x) {x+1} | :puts # prints "1\n"
  # Example: Pipeable(0) | :any_method_accessible_from_caller  
  class Pipeable
    attr_reader :value, :caller

    def self.for(value, caller: nil)
      Pipeable.new(value, caller: caller)
    end

    def initialize(value, caller: nil)
      @value = value
      @caller = caller
    end

    def |(raw_callable)
      if raw_callable.is_a?(Symbol)
        output =
          begin
            __send__(raw_callable, value)
          rescue NoMethodError
            if caller
              caller.__send__(raw_callable, value)
            else
              raise
            end
          end
        Pipeable.new(output, caller: caller)
      elsif [Proc, Method].any? { |x| raw_callable.is_a?(x) }
        Pipeable.new(raw_callable.call(value), caller: caller)
      else
        raise ArgumentError, "'#{raw_callable}' is not callable!"
      end
    end
  end

  def >(*_)
    @value
  end

  # `self` inside this method's body will refer to the caller, allowing
  # Pipeable to support responding correctly to symbols
  def Pipeable(*args)
    Pipeable.for(*args, caller: self)
  end
end
