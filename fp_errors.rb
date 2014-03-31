require 'bigdecimal'

require_relative 'fp_errors_lib'

# See http://en.wikipedia.org/wiki/Floating_point#Accuracy_problems

module FpRoundingErrors
  module Tests
    def self.all
      [
        Test.new('Add a tenth ten times', self.method(:add_a_tenth_ten_times)),
        Test.new('Square a tenth', self.method(:square_a_tenth)),
        Test.new('Associativity', self.method(:associativity)),
        Test.new('Distributivity', self.method(:distributivity)),
        Test.new('Precision after division', self.method(:precision_after_division)),
        Test.new('Precision after power and root', self.method(:precision_after_power_and_root)),
      ]
    end

    def self.add_a_tenth_ten_times(t)
      start = t.("0.0")
      expected = t.("1.0")

      result = 10.times.reduce(start) { |accum, _|
        accum + t.("0.1")
      }

      return_result(expected, result)
    end

    def self.square_a_tenth(t)
      result = t.("0.1") * t.("0.1")
      expected = t.("0.01")

      return_result(expected, result)
    end

    def self.associativity(t)
      a, b, c = t.("1234.567"), t.("45.67834"), t.("0.0004")

      x1 = a + (b + c)
      x2 = (a + b) + c

      return_result(x1, x2)
    end

    def self.distributivity(t)
      a, b, c = t.("1234.567"), t.("1.234567"), t.("3.333333")

      x1 = (a + b) * c
      x2 = (a * c) + (b * c)

      return_result(x1, x2)
    end

    def self.precision_after_division(t)
      # http://stackoverflow.com/questions/17003356/bigdecimal-loses-precision-after-multiplication
      a, b = t.('500'), t.('5.1')

      c = a / b
      d = c * b

      return_result(a, d)
    end

    def self.precision_after_power_and_root(t)
      a, b, c = t.('0.1'), t.('1'), t.('12')

      d = (a ** c)  ** (b / c)

      return_result(a, d)
    end

    private

    def self.return_result(expected, result)
      [pass_or_fail?(result == expected), {
        expected: expected.to_s,
        got: result.to_s,
        delta: (expected - result).to_s
      }]
    end

    def self.pass_or_fail?(bool_expression)
      if (bool_expression)
        :pass
      else
        :fail
      end
    end
  end


  module Types
    def self.all
      [Type.new(Float, ->(x) { x.to_f }),
       Type.new(Rational, ->(x) { x.to_r }),
       Type.new(BigDecimal, ->(x) { BigDecimal(x) })]
    end
  end
end