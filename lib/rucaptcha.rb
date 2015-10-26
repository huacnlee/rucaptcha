require 'active_support/core_ext'
require_relative 'rucaptcha/version'
require_relative 'rucaptcha/configuration'
require_relative 'rucaptcha/controller_helpers'
require_relative 'rucaptcha/view_helpers'
require_relative 'rucaptcha/captcha'
require_relative 'rucaptcha/engine'

module RuCaptcha
  class << self
    def config
      return @config if defined?(@config)
      @config = Configuration.new
      @config.len = 4
      @config.width = 150
      @config.height = 48
      @config.implode = 0.4
      @config
    end

    def configure(&block)
      config.instance_exec(&block)
    end
  end
end


ActionController::Base.send :include, RuCaptcha::ControllerHelpers
ActionView::Base.send :include, RuCaptcha::ViewHelpers
