require "rails"
require "action_controller"
require "active_support/all"

begin
  # load the precompiled extension file
  ruby_version = /(\d+\.\d+)/.match(::RUBY_VERSION)
  require_relative "rucaptcha/#{ruby_version}/rucaptcha"
rescue LoadError
  require "rucaptcha/rucaptcha"
end

require "rucaptcha/version"
require "rucaptcha/configuration"
require "rucaptcha/controller_helpers"
require "rucaptcha/view_helpers"
require "rucaptcha/cache"
require "rucaptcha/engine"
require "rucaptcha/errors/configuration"

module RuCaptcha
  class << self
    def config
      return @config if defined?(@config)

      @config = Configuration.new
      @config.length = 5
      @config.difficulty = 3
      @config.expires_in = 2.minutes
      @config.skip_cache_store_check = false
      @config.line = true
      @config.noise = false
      @config.circle = true
      @config.format = "png"
      @config.mount_path = "/rucaptcha"
      @config.case_sensitive = false

      @config.cache_store = if Rails.application
                              Rails.application.config.cache_store
                            else
                              :mem_cache_store
                            end
      @config.cache_store
      @config
    end

    def configure(&block)
      config.instance_exec(&block)
    end

    def generate
      length = config.length

      raise RuCaptcha::Errors::Configuration, "length config error, value must in 3..7" unless length.in?(3..7)

      result = RuCaptchaCore.create(length, config.difficulty || 5, config.line, config.noise, config.circle, config.format)
      unless config.case_sensitive
        result[0].downcase!
      end

      [result[0], result[1].pack("c*")]
    end

    def check_cache_store!
      cache_store = RuCaptcha.config.cache_store
      store_name = cache_store.is_a?(Array) ? cache_store.first : cache_store
      if %i[memory_store null_store file_store].include?(store_name)
        RuCaptcha.config.cache_store = [:file_store, Rails.root.join("tmp/cache/rucaptcha/session")]

        puts "

  RuCaptcha's cache_store requirements are stored across processes and machines,
  such as :mem_cache_store, :redis_store, or other distributed storage.
  But your current set is #{cache_store}, it has changed to :file_store for working.
  NOTE: :file_store is still not a good way, it only works with single server case.

  Please make config file `config/initializers/rucaptcha.rb` to setup `cache_store`.
  More infomation please read GitHub RuCaptcha README file.
  https://github.com/huacnlee/rucaptcha

"
      end
    end
  end
end

ActiveSupport.on_load(:action_controller) do
  ActionController::Base.include RuCaptcha::ControllerHelpers
end

ActiveSupport.on_load(:action_view) do
  include RuCaptcha::ViewHelpers
end
