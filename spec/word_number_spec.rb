require_relative '../word_number'
require_relative '../fixnum'
require_relative '../bignum'

describe Fixnum do
  it "should be able to split a number into an array" do
    expect(456.split_number).to eq([4,5,6])
  end
end

describe WordNumber do

  let (:number) {@number = WordNumber.new(number=2573317)}
  #let (:number) {@number = WordNumber.new(number=1)}
  it "should have a method called number_to_word" do
    expect(number).to respond_to :to_word
  end
  it "to_word should return a value" do
    expect(number.to_word).not_to eq(nil)
  end
  it "to_word should return a string length of minimum 3" do
    expect(number.to_word.length >= 3).to be(true)
  end
  it "should have a convert_digit method" do
    expect(number).to respond_to :convert_digit
  end
  it "convert_digit should return an a string" do
    single_digits = [*0..9].map{|n| n}
    single_digits.each do |single_digit|
      expect(number.convert_digit(single_digit)).to be_a(String)
    end
  end
  it "should add an appropriate suffix to teen words" do
    expect(number.suffix("one", 'teen')).to eq("eleven")
    expect(number.suffix("two", 'teen')).to eq("twelve")
    expect(number.suffix("three", 'teen')).to eq("thirteen")
    expect(number.suffix("five", 'teen')).to eq("fifteen")
  end
  it "should add an appropriate suffix to hundred words" do
    expect(number.suffix("one", 'ten')).to eq('ten')
    expect(number.suffix("two", 'ten')).to eq("twenty")
    expect(number.suffix("three", 'ten')).to eq("thirty")
    expect(number.suffix("four", 'ten')).to eq("forty")
    expect(number.suffix("five", 'ten')).to eq("fifty")
    expect(number.suffix("six", 'ten')).to eq("sixty")
  end

  let (:num1) {@number = WordNumber.new(number=2573317)}
  let (:num2) {@number = WordNumber.new(number=100)}
  let (:num3) {@number = WordNumber.new(number=101)}
  let (:num4) {@number = WordNumber.new(number=111)}
  let (:num5) {@number = WordNumber.new(number=111111)}
  let (:num6) {@number = WordNumber.new(number=200001)}
  let (:num7) {@number = WordNumber.new(number=10221)}
  let (:ten) {@number = WordNumber.new(number=10)}

  it "should find correct words on all numbers" do
    expect(num1.to_word).to eq('two million five hundred and seventy three thousand three hundred and seventeen')
    expect(num2.to_word).to eq('one hundred')
    expect(num3.to_word).to eq('one hundred and one')
    expect(num4.to_word).to eq('one hundred and eleven')
    expect(num5.to_word).to eq('one hundred and eleven thousand one hundred and eleven')
    expect(num6.to_word).to eq('two hundred thousand and one')
    expect(num7.to_word).to eq('ten thousand two hundred and twenty one')
    expect(ten.to_word).to eq('ten')
  end
end
