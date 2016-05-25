require 'spec_helper'

describe RuCaptcha::Cache do
  before(:all) do
    RuCaptcha::Captcha.send(:prepend, RuCaptcha::Cache)
  end

  describe '.random_chars_with_cache' do
    it 'should generate max chars by config.cache_limit' do
      allow(RuCaptcha.config).to receive(:cache_limit).and_return(5)
      items = []
      100.times do
        items << RuCaptcha::Captcha.random_chars
      end
      expect(items.uniq.length).to eq RuCaptcha.config.cache_limit
      expect(RuCaptcha::Captcha.cached_codes).to eq items.uniq
    end
  end

  describe '.create' do
    it 'should work' do
      expect(RuCaptcha::Captcha).to receive(:create).and_return('aabb')
      expect(RuCaptcha::Captcha.create('abcd')).to eq('aabb')
    end
  end
end
