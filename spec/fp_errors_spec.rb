require_relative '../fp_errors'

describe FpRoundingErrors::Type do
  describe '#to_s' do
    it 'returns the name of the embedded type\'s class' do
      subject = described_class.new(Float, nil)
      expect(subject.to_s).to eq('Float')
    end
  end

  describe '#to_proc' do
    it 'returns a #to_type method object' do
      subject = described_class.new(Float, ->(x) { x.to_f })
      callable = subject.to_proc
      expect(callable).to be_a(Method)
      expect(callable.('7.0')).to eq(7.0)
    end
  end

  it 'knows how to convert a string value to the embedded type' do
    subject = described_class.new(Float, ->(x) { x.to_f })
    expect(subject.to_type('9.99')).to be_a(Float)
    expect(subject.to_type('9.99')).to eq(9.99)
  end
end

describe FpRoundingErrors::Test do
  describe "#run" do
    it "runs the encapsulated test function" do
      was_run = false
      subject = described_class.new('test name', ->(not_used) { was_run = true })

      expect(was_run).to be_false
      subject.run(double(to_proc: ->() {}))
      expect(was_run).to be_true
    end

    it "passes the type conversion proc as an argument to the test function" do
      subject = described_class.new('test name', ->(type_proc) { ['result', type_proc.call] })
      type = double(to_proc: ->() { 'I was called' })

      result = subject.run(type)

      expect(result.info).to eq('I was called')
    end

    it "returns a Result object" do
      subject = described_class.new('test name', ->(_) { 'test was called' })
      type = double(to_proc: ->() {})

      result = subject.run(type)

      expect(result).to be_an_instance_of(FpRoundingErrors::Result)
      expect(result.test).to be(subject)
      expect(result.type).to be(type)
    end
  end
end

describe FpRoundingErrors::TestRunner do
  describe '#run_all' do
    it 'returns a collection containing all of the test results' do
      subject = described_class.new(
        [:not_a_real_test1, :not_a_real_test2],
        [:not_a_real_type1, :not_a_real_type2])

      allow(described_class).to receive(:run) do |test, type|
        type
      end

      results = subject.run_all

      expect(results).to eq([
        [:not_a_real_test1,
          [:not_a_real_type1, :not_a_real_type2]],
        [:not_a_real_test2,
          [:not_a_real_type1, :not_a_real_type2]],
      ])
    end
  end

  describe '.run' do
    it 'returns the result of running the given test with the given type' do
      test = double()
      type = double()
      result = double()
      expect(test).to receive(:run).with(type).and_return(result)
      expect(described_class.run(test, type)).to eq(result)
    end
  end

  it 'runs a set of tests with a set of types' do
    test = FpRoundingErrors::Test.new(
      'add_a_tenth_ten_times', FpRoundingErrors::Tests.method(:add_a_tenth_ten_times))
    type = FpRoundingErrors::Type.new(Float, ->(x) { x.to_f })

    subject = described_class.new([test], [type])

    results = subject.run_all

    expect(results.length).to eq(1)
    expect(results[0][0]).to be(test)
  end
end
