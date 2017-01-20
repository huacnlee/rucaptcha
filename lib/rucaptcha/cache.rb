require 'fileutils'

module RuCaptcha
  class << self
    def cache
      return @cache if defined? @cache
      @cache = ActiveSupport::Cache.lookup_store(RuCaptcha.config.cache_store)
      @cache
    end
  end
end
