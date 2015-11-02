module RuCaptcha
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :verify_rucaptcha?
    end

    def generate_rucaptcha
      session[:_rucaptcha] = RuCaptcha::Captcha.random_chars
      RuCaptcha::Captcha.create(session[:_rucaptcha])
    end

    def verify_rucaptcha?(resource = nil)
      right = params[:_rucaptcha].present? && session[:_rucaptcha].present? &&
              params[:_rucaptcha].downcase.strip == session[:_rucaptcha]
      if resource && resource.respond_to?(:errors)
        resource.errors.add(:base, t('rucaptcha.invalid')) unless right
      end
      session.delete(:_rucaptcha)
      right
    end
  end
end
