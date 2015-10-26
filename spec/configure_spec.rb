require 'spec_helper'

describe RuCaptcha do
  describe 'normal' do
    it 'should read right config with spec_helper set' do
      expect(RuCaptcha.config.len).to eq(2)
      expect(RuCaptcha.config.width).to eq(123)
      expect(RuCaptcha.config.height).to eq(33)
      expect(RuCaptcha.config.implode).to eq(0.111)
    end
  end
end
