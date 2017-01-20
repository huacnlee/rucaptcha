require 'rails'
require 'action_controller'
require 'active_support/all'
require_relative 'rucaptcha/rucaptcha'
require_relative 'rucaptcha/version'
require_relative 'rucaptcha/configuration'
require_relative 'rucaptcha/controller_helpers'
require_relative 'rucaptcha/view_helpers'
require_relative 'rucaptcha/cache'
require_relative 'rucaptcha/engine'

module RuCaptcha
  class << self
    def config
      return @config if defined?(@config)
      @config = Configuration.new
      @config.cache_limit = 100
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
  end
end

ActionController::Base.send(:include, RuCaptcha::ControllerHelpers)
ActionView::Base.send(:include, RuCaptcha::ViewHelpers)
