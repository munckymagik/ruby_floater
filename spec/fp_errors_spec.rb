require_relative '../fp_errors'

describe FpRoundingErrors do
  describe ".add_a_tenth_ten_times" do
    it 'calls the type convertor to convert operands from strings' do
      called = false
      convertor = ->(x) {
        called = true
        expect(x).to be_a(String)
        x.to_f
      }

      described_class.add_a_tenth_ten_times(convertor)
      expect(called).to be_true
    end

    it 'returns a result object' do
      result = described_class.add_a_tenth_ten_times(->(x) { x.to_f })
      expect(result.name.to_s).to eq('add_a_tenth_ten_times')
      expect(result.values.length).to be >= 1
      expect(result).to respond_to(:error)
    end
  end
end

describe FpRoundingErrors::TestRunner do
  describe '#run_all' do
    it 'returns a collection containing all of the test results' do
      subject = described_class.new(
        [:not_a_real_test1, :not_a_real_test2],
        [:not_a_real_type1, :not_a_real_type2])

      allow(subject).to receive(:run) do |test, type|
        test
      end

      results = subject.run_all

      expect(results).to eq([
        [:not_a_real_type1, [:not_a_real_test1, :not_a_real_test2]],
        [:not_a_real_type2, [:not_a_real_test1, :not_a_real_test2]],
      ])
    end
  end

  describe '.run' do
    it 'returns the result of applying the given test with the given type' do
      test = double()
      type = double()
      result = double()
      expect(test).to receive(:apply).with(type).and_return(result)
      expect(described_class.run(test, type)).to eq(result)
    end
  end
end