require 'spec_helper'

RSpec.describe String, "#expand" do
  using StringExpansion

  context 'when String is "abc"' do
    it 'should return ["abc"]' do
      expect("abc".expand).to eq ["abc"]
    end
  end

  context 'when String is ""' do
    xit 'should return [""]' do
      expect("".expand).to eq [""]
    end
  end

  context 'when String is "a[0-1]"' do
    it 'should return ["a0", "a1"]' do
      expect("a[0-1]".expand).to eq ["a0", "a1"]
    end
  end

  context 'when String is "a[100-110]"' do
    it 'should return an array that begins "a[100]" and ends with "a[110]"' do
      expected = (100..110).to_a.map {|n| "a#{n}" }
      expect("a[100-110]".expand).to eq expected
    end
  end

  context 'when String is "[200-203]x"' do
    it 'should return ["200x", "201x", "202x", "203x"]' do
      expect("[200-203]x".expand).to eq ["200x", "201x", "202x", "203x"]
    end
  end

  context 'when String is "abc[99-96]"' do
    it 'should return ["abc99", "abc98", "abc97", "abc96"]' do
      expect("abc[99-96]".expand).to eq ["abc99", "abc98", "abc97", "abc96"]
    end
  end

  context 'when String is "x[0001-0003]"' do
    it 'should return ["x0001", "x0002", "x0003"]' do
      expect("x[0001-0003]".expand).to eq ["x0001", "x0002", "x0003"]
    end
  end

  context 'when String is "[9-10]"' do
    it 'should return ["9", "10"]' do
      expect("[9-10]".expand).to eq ["9", "10"]
    end
  end

  context 'when String is "[08-10]"' do
    it 'should return ["08", "09", "10"]' do
      expect("[08-10]".expand).to eq ["08", "09", "10"]
    end
  end

  context 'when String is "[10-08]"' do
    it 'should return ["10", "09", "08"]' do
      expect("[10-08]".expand).to eq ["10", "09", "08"]
    end
  end

  context 'when String is "[10-8]"' do
    it 'should return ["10", "9", "8"]' do
      expect("[10-8]".expand).to eq ["10", "9", "8"]
    end
  end

  context 'when String is "x[a-c]"' do
    it 'should return ["xa", "xb", "xc"]' do
      expect("x[a-c]".expand).to eq ["xa", "xb", "xc"]
    end
  end

  context 'when String is "a[z-x]"' do
    it 'should return ["az", "ay", "ax"]' do
      expect("a[z-x]".expand).to eq ["az", "ay", "ax"]
    end
  end

  context 'when String is "x[A-C]"' do
    it 'should return ["xA", "xB", "xC"]' do
      expect("x[A-C]".expand).to eq ["xA", "xB", "xC"]
    end
  end

  context 'when String is "a[Z-X]"' do
    it 'should return ["aZ", "aY", "aX"]' do
      expect("a[Z-X]".expand).to eq ["aZ", "aY", "aX"]
    end
  end

  context 'when String is "x[1-3][a-b]"' do
    it 'should return ["x1a", "x1b", "x2a", "x2b", "x3a", "x3b"]' do
      expect("x[1-3][a-b]".expand).to eq ["x1a", "x1b", "x2a", "x2b", "x3a", "x3b"]
    end
  end
end
