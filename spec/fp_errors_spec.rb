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

    it "returns a result object" do
      result = described_class.add_a_tenth_ten_times(->(x) { x.to_f })
      expect(result.name.to_s).to eq('add_a_tenth_ten_times')
      expect(result.values.length).to be >= 1
      expect(result).to respond_to(:error)
    end
  end
end