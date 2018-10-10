module RuCaptcha
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :verify_rucaptcha?
    end

    # session key of rucaptcha
    def rucaptcha_sesion_key_key
      session_id = session.respond_to?(:id) ? session.id : session[:session_id]
      warning_when_session_invalid if session_id.blank?
      ['rucaptcha-session', session_id].join(':')
    end

    # Generate a new Captcha
    def generate_rucaptcha
      res = RuCaptcha.generate()
      session_val = {
        code: res[0],
        time: Time.now.to_i
      }
      RuCaptcha.cache.write(rucaptcha_sesion_key_key, session_val, expires_in: RuCaptcha.config.expires_in)
      res[1]
    end

    # Verify captcha code
    #
    # params:
    # resource - [optional] a ActiveModel object, if given will add validation error message to object.
    # :keep_session - if true, RuCaptcha will not delete the captcha code session.
    # :captcha - if given, the value of it will be used to verify the captcha,
    #            if do not give or blank, the value of params[:_rucaptcha] will be used to verify the captcha
    #
    # exmaples:
    #
    #   verify_rucaptcha?
    #   verify_rucaptcha?(user, keep_session: true)
    #   verify_rucaptcha?(nil, keep_session: true)
    #   verify_rucaptcha?(nil, captcha: params[:user][:captcha])
    #
    def verify_rucaptcha?(resource = nil, opts = {})
      opts ||= {}

      store_info = RuCaptcha.cache.read(rucaptcha_sesion_key_key)
      # make sure move used key
      RuCaptcha.cache.delete(rucaptcha_sesion_key_key) unless opts[:keep_session]

      # Make sure session exist
      if store_info.blank?
        return add_rucaptcha_validation_error
      end

      # Make sure not expire
      if (Time.now.to_i - store_info[:time]) > RuCaptcha.config.expires_in
        return add_rucaptcha_validation_error
      end

      # Make sure parama have captcha
      captcha = (opts[:captcha] || params[:_rucaptcha] || '').downcase.strip
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

    def warning_when_session_invalid
      Rails.logger.warn "
        WARNING! The session.id is blank, RuCaptcha can't work properly, please keep session available.
        More details about this: https://github.com/huacnlee/rucaptcha/pull/66
      "
    end
  end
end
