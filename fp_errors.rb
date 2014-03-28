require 'bigdecimal'

# See http://en.wikipedia.org/wiki/Floating_point#Accuracy_problems

module FpRoundingErrors
  def self.run_tests
    test_runner = TestRunner.new(
      # Tests
      [Test.new(self.method(:add_a_tenth_ten_times))],

      # Types
      [Type.new(Float, ->(x) { x.to_f }),
       Type.new(Rational, ->(x) { x.to_r }),
       Type.new(BigDecimal, ->(x) { BigDecimal(x) })]
    )

    test_runner.run_all
  end

  def self.add_a_tenth_ten_times(t)
    a = t.("0.0")
    b = t.("1.0")

    c = 10.times.reduce(a) { |accum, _|
      accum + t.("0.1")
    }

    Result.new(__method__, [c], c - b)
  end
end

module FpRoundingErrors
  class Type
    def initialize(type_class, convertor)
      @type_class = type_class
      @convertor = convertor
    end

    def to_s
      @type_class.to_s
    end

    def to_type(value)
      @convertor.call(value)
    end

    def to_proc
      self.method(:to_type)
    end
  end

  class Test
    def initialize(test_proc)
      @test_proc = test_proc
    end

    def run(type)
      @test_proc.call(type.to_proc)
    end
  end

  class Result
    attr_reader :name, :values, :error

    def initialize(name, values, error)
      @name = name
      @values = values
      @error = error
    end
  end

  class TestRunner
    def initialize(tests, types)
      @tests = tests
      @types = types
    end

    def run_all
      @types.map do |type|
        results = @tests.map do |test|
          self.class.run(test, type)
        end

        [type, results]
      end
    end

    def self.run(test, type)
      test.run(type)
    end
  end
end