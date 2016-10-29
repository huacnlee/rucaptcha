require 'rails'
require 'action_controller'
require 'active_support/all'
require_relative 'rucaptcha/version'
require_relative 'rucaptcha/configuration'
require_relative 'rucaptcha/controller_helpers'
require_relative 'rucaptcha/view_helpers'
require_relative 'rucaptcha/cache'
require_relative 'rucaptcha/captcha'
require_relative 'rucaptcha/engine'

module RuCaptcha
  class << self
    def config
      return @config if defined?(@config)
      @config = Configuration.new
      @config.len         = 4
      @config.font_size   = 45
      @config.implode     = 0.3
      @config.cache_limit = 100
      @config.expires_in  = 2.minutes
      @config.style       = :colorful
      if Rails.application
        @config.cache_store = Rails.application.config.cache_store
      else
        @config.cache_store = :null_store
      end
      @config
    end

    def configure(&block)
      config.instance_exec(&block)
    end
  end
end

ActionController::Base.send(:include, RuCaptcha::ControllerHelpers)
ActionView::Base.send(:include, RuCaptcha::ViewHelpers)
