module RuCaptcha
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :verify_rucaptcha?
    end

    def generate_rucaptcha
      session[:_rucaptcha]   = RuCaptcha::Captcha.random_chars
      session[:_rucaptcha_at] = Time.now.to_i

      RuCaptcha::Captcha.create(session[:_rucaptcha])
    end

    def verify_rucaptcha?(resource = nil)
      rucaptcha_at = session[:_rucaptcha_at].to_i
      captcha = (params[:_rucaptcha] || '').downcase.strip

      # Captcha chars in Session expire in 2 minutes
      valid = false
      if (Time.now.to_i - rucaptcha_at) <= RuCaptcha.config.expires_in
        valid = captcha.present? && captcha == session.delete(:_rucaptcha)
      end

      if resource && resource.respond_to?(:errors)
        resource.errors.add(:base, t('rucaptcha.invalid')) unless valid
      end

      valid
    end
  end
end
