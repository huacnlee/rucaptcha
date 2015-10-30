require 'spec_helper'

describe RuCaptcha::Captcha do
  describe '.random_chars' do
    it 'should len equal config.len' do
      expect(RuCaptcha::Captcha.random_chars_without_cache.length).to eq(RuCaptcha.config.len)
    end

    it 'should return 0-9 and lower str' do
      expect(RuCaptcha::Captcha.random_chars_without_cache).to match(/[a-z0-9]/)
    end

    it 'should not include [0ol1]' do
      10000.times do
        expect(RuCaptcha::Captcha.random_chars_without_cache).not_to match(/[0ol1]/i)
      end
    end
  end
end
