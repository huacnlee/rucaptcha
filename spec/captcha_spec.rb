require "spec_helper"

describe RuCaptcha do
  describe ".generate" do
    it "should work" do
      res = RuCaptcha.generate
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end
  end

  describe ".create" do
    it "should len equal config.len" do
      res = RuCaptchaCore.create(5, 3, true, true, "png")
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end

    it "should work with color style" do
      res = RuCaptchaCore.create(5, 3, true, true, "png")
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end

    it "should raise when length not in 3..7 " do
      RuCaptcha.configure do
        self.length = 2
      end
      # expect(RuCaptcha.generate()).to raise_error('length config error, value must in 3..7')
      expect { RuCaptcha.generate }
        .to raise_error("length config error, value must in 3..7")
      RuCaptcha.configure do
        self.length = 5
      end
    end

    it "should work when length in 3..7 " do
      RuCaptcha.configure do
        self.length = 5
      end
      res = RuCaptcha.generate
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(5)
      expect(res[1]).not_to eq(nil)
    end

    it "should len equal 3" do
      res = RuCaptchaCore.create(3, 3, true, true, "png")
      expect(res.length).to eq(2)
      expect(res[0].length).to eq(3)
      expect(res[1]).not_to eq(nil)
    end
  end
end
