require 'spec_helper'

describe RuCaptcha::Captcha do
  describe '.random_chars' do
    it 'should len equal config.len' do
      expect(RuCaptcha::Captcha.random_chars.length).to eq(RuCaptcha.config.len)
    end

    it 'should return 0-9 and lower str' do
      expect(RuCaptcha::Captcha.random_chars).to match(/[a-z0-9]/)
    end

    it 'should not include [0ol1]' do
      10_000.times do
        expect(RuCaptcha::Captcha.random_chars).not_to match(/[0ol1]/i)
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

  describe '.rand_line_top' do
    it 'should work' do
      expect(RuCaptcha::Captcha.send(:rand_line_top, 1, 24)).to be_a(Integer)
    end
  end

  describe '.uniq_rgbs_for_each_chars' do
    let(:chars) { %w(a b c d e) }
    let(:colors) { RuCaptcha::Captcha.send(:uniq_rgbs_for_each_chars, chars) }

    it 'should work' do
      expect(colors.length).to eq chars.length
      expect(colors[0].length).to eq 3
    end

    it 'Be sure the color not same as preview color' do
      pre_rgb = nil
      colors.each do |rgb|
        if pre_rgb
          same = rgb.index(rgb.min) == pre_rgb.index(rgb.min) && rgb.index(rgb.max) == pre_rgb.index(pre_rgb.max)
          expect(same).not_to eq true
        end
        pre_rgb = rgb
      end
    end
  end
end
