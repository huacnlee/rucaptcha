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
      right = params[:_rucaptcha].present? && session[:_rucaptcha].present? &&
              (Time.now.to_i - session[:_rucaptcha_at].to_i) < RuCaptcha.config.expires_in &&
              params[:_rucaptcha].downcase.strip == session[:_rucaptcha]

      if resource && resource.respond_to?(:errors)
        resource.errors.add(:base, t('rucaptcha.invalid')) unless right
      end
      right
    end
  end
end
