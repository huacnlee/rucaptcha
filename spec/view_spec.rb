require "spec_helper"

describe ActionView::Base do
  describe ".rucaptcha_input_tag" do
    let(:context) { ActionView::LookupContext.new([]) }
    let(:view) { ActionView::Base.new(context) }

    it "should work" do
      expect(view.respond_to?(:rucaptcha_input_tag)).to eq true
    end

    it "input maxlength should equal to RuCaptcha.config.length" do
      RuCaptcha.config.length += 1
      expect(view.rucaptcha_input_tag.include?("maxlength=\"#{RuCaptcha.config.length}\"")).to eq true
    end
  end
end
