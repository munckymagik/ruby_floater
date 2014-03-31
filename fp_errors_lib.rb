module FpRoundingErrors
  def self.run_tests
    test_runner = TestRunner.new(
      Tests.all,
      Types.all
    )

    test_runner.run_all
  end

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