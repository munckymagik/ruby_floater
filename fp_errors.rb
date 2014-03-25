# See http://en.wikipedia.org/wiki/Floating_point#Accuracy_problems

module FpRoundingErrors
  class Result
    attr_reader :name, :values, :error

    def initialize(name, values, error)
      @name = name
      @values = values
      @error = error
    end
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
