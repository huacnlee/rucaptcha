require 'fileutils'

module RuCaptcha
  class << self
    def cache
      return @cache if defined? @cache

      c = RuCaptcha.config.cache_store
      @cache = ActiveSupport::Cache.lookup_store(*c)
      @cache
    end
  end
end
