require 'spec_helper'

describe RuCaptcha do
  class Simple < ActionController::Base
    def session
      @session ||= {}
    end

    def params
      @params ||= {}
    end
  end

  let(:simple) { Simple.new }

  describe '.generate_rucaptcha' do
    it 'should work' do
      expect(RuCaptcha::Captcha).to receive(:random_chars).and_return('abcd')
      expect(simple.generate_rucaptcha).not_to be_nil
      expect(simple.session[:_rucaptcha]).to eq('abcd')
    end
  end

  describe '.verify_rucaptcha?' do
    context 'Nil of param' do
      it 'should work when params[:_rucaptcha] is nil' do
        simple.params[:_rucaptcha] = nil
        expect(simple.verify_rucaptcha?).to eq(false)
      end

      it 'should work when session[:_rucaptcha] is nil' do
        simple.session[:_rucaptcha] = nil
        simple.params[:_rucaptcha] = 'Abcd'
        expect(simple.verify_rucaptcha?).to eq(false)
      end
    end

    context 'Correct chars in params' do
      it 'should work' do
        simple.session[:_rucaptcha_at] = Time.now.to_i
        simple.session[:_rucaptcha] = 'abcd'
        simple.params[:_rucaptcha] = 'Abcd'
        expect(simple.verify_rucaptcha?).to eq(true)
        simple.params[:_rucaptcha] = 'AbcD'
        expect(simple.verify_rucaptcha?).to eq(true)
      end
    end

    describe 'Incorrect chars' do
      it "should work" do
        simple.session[:_rucaptcha_at] = Time.now.to_i - 60
        simple.session[:_rucaptcha] = 'abcd'
        simple.params[:_rucaptcha] = 'd123'
        expect(simple.verify_rucaptcha?).to eq(false)
      end
    end

    describe 'Expires Session key' do
      it "should work" do
        simple.session[:_rucaptcha_at] = Time.now.to_i - 121
        simple.session[:_rucaptcha] = 'abcd'
        simple.params[:_rucaptcha] = 'abcd'
        expect(simple.verify_rucaptcha?).to eq(false)
      end
    end
  end
end
