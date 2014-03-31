require 'bigdecimal'

# See http://en.wikipedia.org/wiki/Floating_point#Accuracy_problems

module FpRoundingErrors
  def self.run_tests
    test_runner = TestRunner.new(
      # Tests
      [Test.new('Add a tenth ten times', self.method(:add_a_tenth_ten_times))],

      # Types
      [Type.new(Float, ->(x) { x.to_f }),
       Type.new(Rational, ->(x) { x.to_r }),
       Type.new(BigDecimal, ->(x) { BigDecimal(x) })]
    )

    test_runner.run_all
  end

  def self.add_a_tenth_ten_times(t)
    start = t.("0.0")
    expected = t.("1.0")

    result = 10.times.reduce(start) { |accum, _|
      accum + t.("0.1")
    }

    [(result == expected) ? :pass : :fail, {
      expected: expected.to_s,
      got: result.to_s,
      delta: (expected - result).to_s
    }]
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
    def initialize(name, test_proc)
      @test_proc = test_proc
      @name = name
    end

    def run(type)
      result, info = @test_proc.call(type.to_proc)
      Result.new(self, type, result, info)
    end

    def to_s
      @name
    end
  end

  class Result
    attr_reader :test, :type, :result, :info

    def initialize(test, type, result, info)
      @test = test
      @type = type
      @result = result
      @info = info
    end
  end

  class TestRunner
    def initialize(tests, types)
      @tests = tests
      @types = types
    end

    def run_all
      @tests.map do |test|
        results = @types.map do |type|
          self.class.run(test, type)
        end

        [test, results]
      end
    end

    def self.run(test, type)
      test.run(type)
    end
  end
end