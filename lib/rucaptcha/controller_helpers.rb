module RuCaptcha
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :verify_rucaptcha?
    end

    def rucaptcha_sesion_key_key
      ['rucaptcha-session', session.id].join(':')
    end

    def generate_rucaptcha
      code = RuCaptcha::Captcha.random_chars
      session_val = {
        code: code,
        time: Time.now.to_i
      }
      RuCaptcha.cache.write(rucaptcha_sesion_key_key, session_val, expires_in: RuCaptcha.config.expires_in)
      RuCaptcha::Captcha.create(code)
    end

    def verify_rucaptcha?(resource = nil)
      store_info = RuCaptcha.cache.read(rucaptcha_sesion_key_key)
      # make sure move used key
      RuCaptcha.cache.delete(rucaptcha_sesion_key_key)

      # Make sure session exist
      if store_info.blank?
        return add_rucaptcha_validation_error
      end

      # Make sure not expire
      if (Time.now.to_i - store_info[:time]) > RuCaptcha.config.expires_in
        return add_rucaptcha_validation_error
      end

      # Make sure parama have captcha
      captcha = (params[:_rucaptcha] || '').downcase.strip
      if captcha.blank?
        return add_rucaptcha_validation_error
      end

      if captcha != store_info[:code]
        return add_rucaptcha_validation_error
      end

      true
    end

    private

    def add_rucaptcha_validation_error
      if defined?(resource) && resource && resource.respond_to?(:errors)
        resource.errors.add(:base, t('rucaptcha.invalid'))
      end
      false
    end
  end
end
