module RuCaptcha
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :verify_rucaptcha?
    end

    def generate_rucaptcha
      session[:_rucaptcha] = SecureRandom.hex(RuCaptcha.config.len / 2)
      return Captcha.create(session[:_rucaptcha])
    end

    def verify_rucaptcha?(resource = nil)
      right = params[:_rucaptcha].strip == session[:_rucaptcha]
      if resource && resource.respond_to?(:errors)
        resource.errors.add('rucaptcha', 'invalid') unless right
      end
      right
    end
  end
end
