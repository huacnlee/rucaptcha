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
      @config.width       = 150
      @config.height      = 48
      @config.implode     = 0.4
      @config.cache_limit = 100
      @config
    end

    def configure(&block)
      config.instance_exec(&block)

      # enable cache if cache_limit less than 1
      if config.cache_limit >= 1
        RuCaptcha::Captcha.send(:include, RuCaptcha::Cache)
      end
    end
  end
end

ActionController::Base.send(:include, RuCaptcha::ControllerHelpers)
ActionView::Base.send(:include, RuCaptcha::ViewHelpers)
