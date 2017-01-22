require 'spec_helper'

describe RuCaptcha do
  describe '.generate' do
    it 'should work' do
      res = RuCaptcha.generate()
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end
  end

  describe '.create' do
    it 'should len equal config.len' do
      res = RuCaptcha.create(0)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end

    it 'should work with color style' do
      res = RuCaptcha.create(1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end
  end
end
