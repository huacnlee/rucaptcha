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
      res = RuCaptcha.create(0, 5, 1, 1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end

    it 'should work with color style' do
      res = RuCaptcha.create(1, 5, 1, 1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end

    it 'should raise when length not in 3..7 ' do
      RuCaptcha.configure do
        self.length = 2
      end
      #expect(RuCaptcha.generate()).to raise_error('length config error, value must in 3..7')
      expect { RuCaptcha.generate() }.
        to raise_error('length config error, value must in 3..7')
      RuCaptcha.configure do
        self.length = 5
      end
    end

    it 'should work when length in 3..7 ' do
      RuCaptcha.configure do
        self.length = 5
      end
      res = RuCaptcha.generate()
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end

    it 'should len equal 3' do
      res = RuCaptcha.create(1, 3, 1, 1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(3)
      expect(res[1]).not_to eq(nil)
    end

    it 'should len equal 4' do
      res = RuCaptcha.create(1, 4, 1, 1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(4)
      expect(res[1]).not_to eq(nil)
    end

    it 'should len equal 5' do
      res = RuCaptcha.create(1, 5, 1, 1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end

    it 'should len equal 6' do
      res = RuCaptcha.create(1, 6, 1, 1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(6)
      expect(res[1]).not_to eq(nil)
    end

    it 'should len equal 7' do
      res = RuCaptcha.create(1, 7, 0, 1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(7)
      expect(res[1]).not_to eq(nil)
    end

    it 'should work with outline enable' do
      res = RuCaptcha.create(1, 7, 1, 1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(7)
      expect(res[1]).not_to eq(nil)
    end

    it 'should work with outline disable' do
      res = RuCaptcha.create(1, 5, 1, 0)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end

    it 'should work with strikethrough enable' do
      res = RuCaptcha.create(1, 7, 1, 1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(7)
      expect(res[1]).not_to eq(nil)
    end

    it 'should work with strikethrough disable' do
      res = RuCaptcha.create(1, 7, 0, 1)
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(7)
      expect(res[1]).not_to eq(nil)
    end
  end
end
