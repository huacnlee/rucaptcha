require 'rails'
require 'action_controller'
require 'active_support/all'
require 'rucaptcha/rucaptcha'
require 'rucaptcha/version'
require 'rucaptcha/configuration'
require 'rucaptcha/controller_helpers'
require 'rucaptcha/view_helpers'
require 'rucaptcha/cache'
require 'rucaptcha/engine'

module RuCaptcha
  class << self
    def config
      return @config if defined?(@config)
      @config = Configuration.new
      @config.style       = :colorful
      @config.expires_in  = 2.minutes
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

    def generate()
      style = config.style == :colorful ? 1 : 0
      self.create(style)
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  ActionController::Base.send :include, RuCaptcha::ControllerHelpers
end

ActiveSupport.on_load(:active_view) do
  include RuCaptcha::ViewHelpers
end
