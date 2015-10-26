module RuCaptcha
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :verify_rucaptcha?
    end

    def generate_rucaptcha
      session[:_rucaptcha] = random_rucaptcha_chars
      return RuCaptcha::Captcha.create(session[:_rucaptcha])
    end

    def random_rucaptcha_chars
      chars = SecureRandom.hex(RuCaptcha.config.len / 2).downcase
      chars.gsub!(/[0ol1]/i, (rand(9) + 1).to_s)
      chars
    end

    def verify_rucaptcha?(resource = nil)
      params[:_rucaptcha] ||= ''
      right = params[:_rucaptcha].downcase.strip == session[:_rucaptcha]
      if resource && resource.respond_to?(:errors)
        resource.errors.add(:base, t('rucaptcha.invalid')) unless right
      end
      right
    end
  end
end
