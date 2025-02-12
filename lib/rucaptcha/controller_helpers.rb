module RuCaptcha
  module ControllerHelpers
    extend ActiveSupport::Concern

    included do
      helper_method :verify_rucaptcha?
    end

    def rucaptcha_session_id
      cookies[:_rucaptcha_session_id]
    end

    # session key of rucaptcha
    def rucaptcha_sesion_key_key
      warning_when_session_invalid if rucaptcha_session_id.blank?

      # With https://github.com/rack/rack/commit/7fecaee81f59926b6e1913511c90650e76673b38
      # to protected session_id into secret
      session_id_digest = Digest::SHA256.hexdigest(rucaptcha_session_id.inspect)
      ["rucaptcha-session", session_id_digest].join(":")
    end

    # Generate a new Captcha
    def generate_rucaptcha
      generate_rucaptcha_session_id

      res = RuCaptcha.generate
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
    def verify_rucaptcha?(_resource = nil, opts = {})
      opts ||= {}

      store_info = RuCaptcha.cache.read(rucaptcha_sesion_key_key)
      # make sure move used key
      RuCaptcha.cache.delete(rucaptcha_sesion_key_key) unless opts[:keep_session]

      # Make sure session exist
      return add_rucaptcha_validation_error if store_info.blank?

      # Make sure not expire
      return add_rucaptcha_validation_error if (Time.now.to_i - store_info[:time]) > RuCaptcha.config.expires_in

      # Make sure parama have captcha
      captcha = (opts[:captcha] || params[:_rucaptcha] || "").strip
      saved_code = store_info[:code]

      return add_rucaptcha_validation_error if captcha.blank?

      unless RuCaptcha.config.case_sensitive
        captcha.downcase!
        saved_code.downcase!
      end

      return add_rucaptcha_validation_error if captcha != saved_code

      true
    end

    private

    def generate_rucaptcha_session_id
      return if rucaptcha_session_id.present?

      cookies[:_rucaptcha_session_id] = {
        value: SecureRandom.hex(16),
        expires: 1.day
      }
    end

    def add_rucaptcha_validation_error
      if defined?(resource) && resource && resource.respond_to?(:errors)
        resource.errors.add(:base, t("rucaptcha.invalid"))
      end
      false
    end

    def warning_when_session_invalid
      return unless Rails.env.development?

      Rails.logger.warn "
        WARNING! The session.id is blank, RuCaptcha can't work properly, please keep session available.
        More details about this: https://github.com/huacnlee/rucaptcha/pull/66
      "
    end
  end
end
