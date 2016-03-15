require 'spec_helper'

describe RuCaptcha do
  describe 'normal' do
    it 'should read right config with spec_helper set' do
      expect(RuCaptcha.config.len).to eq(2)
      expect(RuCaptcha.config.font_size).to eq(48)
      expect(RuCaptcha.config.implode).to eq(0.111)
      expect(RuCaptcha.config.expires_in).to eq(2.minutes)
    end
  end
end
