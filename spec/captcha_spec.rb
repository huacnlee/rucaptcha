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

  describe '.random_color' do
    it 'should return colorful array' do
      allow(RuCaptcha.config).to receive(:style).and_return(:colorful)
      colors = RuCaptcha::Captcha.random_color
      expect(colors.uniq.size >= 2).to eq true
      colors1 = RuCaptcha::Captcha.random_color
      expect(colors).not_to eq colors1
    end

    it 'should return black color array' do
      allow(RuCaptcha.config).to receive(:style).and_return(:black_white)
      colors = RuCaptcha::Captcha.random_color
      expect(colors.uniq.size).to eq 1
      colors1 = RuCaptcha::Captcha.random_color
      expect(colors).not_to eq colors1
    end
  end
end
