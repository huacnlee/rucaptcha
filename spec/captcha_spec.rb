require 'spec_helper'

describe RuCaptcha do
  describe '.create' do
    it 'should len equal config.len' do
      res = RuCaptcha.create()
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end
  end
end
