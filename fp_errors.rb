require 'bigdecimal'

require_relative 'fp_errors_lib'

# See http://en.wikipedia.org/wiki/Floating_point#Accuracy_problems

module FpRoundingErrors
  module Tests
    def self.all
      [
        Test.new('Add a tenth ten times', self.method(:add_a_tenth_ten_times)),
      ]
    end

    def self.add_a_tenth_ten_times(t)
      start = t.("0.0")
      expected = t.("1.0")

      result = 10.times.reduce(start) { |accum, _|
        accum + t.("0.1")
      }

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