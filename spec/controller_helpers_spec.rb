require "spec_helper"
require "securerandom"

describe RuCaptcha do
  class SimpleController < ActionController::Base
    def params
      @params ||= {}
    end

    def custom_session
      RuCaptcha.cache.read(rucaptcha_sesion_key_key)
    end

    def clean_custom_session
      RuCaptcha.cache.delete(rucaptcha_sesion_key_key)
    end
  end

  let(:simple) { SimpleController.new }
  let(:cookies) { {} }

  before(:each) do
    allow(simple).to receive(:cookies).and_return(cookies)
    simple.send(:generate_rucaptcha_session_id)
    if cookies[:rucaptcha_session_id].is_a?(Hash)
      cookies[:rucaptcha_session_id] = cookies[:rucaptcha_session_id][:value]
    end
  end

  describe ".generate_rucaptcha_session_id" do
    it "should work" do
      expect(cookies[:rucaptcha_session_id]).to be_present
      expect(simple.rucaptcha_session_id).to eq(cookies[:rucaptcha_session_id])

      old_session_id = simple.rucaptcha_session_id
      simple.send(:generate_rucaptcha_session_id)
      expect(simple.rucaptcha_session_id).to eq(old_session_id)
    end
  end

  describe ".rucaptcha_sesion_key_key" do
    it "should work" do
      session_id_digest = Digest::SHA256.hexdigest(simple.rucaptcha_session_id.inspect)
      expect(simple.rucaptcha_sesion_key_key).to eq ["rucaptcha-session", session_id_digest].join(":")
    end
  end

  describe ".generate_rucaptcha" do
    it "should work" do
      allow(RuCaptcha).to receive(:create).and_return(["abcde", "fake image data"])
      expect(simple.generate_rucaptcha).to eq "fake image data"
      expect(simple.custom_session[:code]).to eq("abcde")
    end
  end

  describe ".verify_rucaptcha?" do
    context "Nil of param" do
      it "should work when params[:_rucaptcha] is nil" do
        simple.params[:_rucaptcha] = nil
        expect(simple.verify_rucaptcha?).to eq(false)
      end

      it "should work when session[:_rucaptcha] is nil" do
        simple.clean_custom_session
        simple.params[:_rucaptcha] = "Abcd"
        expect(simple.verify_rucaptcha?).to eq(false)
      end
    end

    context "Correct chars in params" do
      it "should work" do
        RuCaptcha.cache.write(simple.rucaptcha_sesion_key_key, {
          time: Time.now.to_i,
          code: "abcd"
        })
        simple.params[:_rucaptcha] = "Abcd"
        expect(simple.verify_rucaptcha?).to eq(true)
        expect(simple.custom_session).to eq nil

        RuCaptcha.cache.write(simple.rucaptcha_sesion_key_key, {
          time: Time.now.to_i,
          code: "abcd"
        })
        simple.params[:_rucaptcha] = "AbcD"
        expect(simple.verify_rucaptcha?).to eq(true)
      end

      it "should keep session when given :keep_session" do
        RuCaptcha.cache.write(simple.rucaptcha_sesion_key_key, {
          time: Time.now.to_i,
          code: "abcd"
        })
        simple.params[:_rucaptcha] = "abcd"
        expect(simple.verify_rucaptcha?(nil, keep_session: true)).to eq(true)
        expect(simple.custom_session).not_to eq nil
        expect(simple.verify_rucaptcha?).to eq(true)
        expect(simple.verify_rucaptcha?).to eq(false)
      end
    end

    describe "Incorrect chars" do
      it "should work" do
        RuCaptcha.cache.write(simple.rucaptcha_sesion_key_key, {
          time: Time.now.to_i - 60,
          code: "abcd"
        })
        simple.params[:_rucaptcha] = "d123"
        expect(simple.verify_rucaptcha?).to eq(false)
        expect(simple.custom_session).to eq nil
      end
    end

    describe "Expires Session key" do
      it "should work" do
        RuCaptcha.cache.write(simple.rucaptcha_sesion_key_key, {
          time: Time.now.to_i - 121,
          code: "abcd"
        })
        simple.params[:_rucaptcha] = "abcd"
        expect(simple.verify_rucaptcha?).to eq(false)
      end
    end
  end
end
