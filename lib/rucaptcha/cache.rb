require 'fileutils'

module RuCaptcha
  class << self
    def cache
      return @cache if defined? @cache
      @cache = ActiveSupport::Cache.lookup_store(RuCaptcha.config.cache_store)
      @cache
    end
  end

  # File Cache
  module Cache
    def self.prepended(base)
      class << base
        prepend ClassMethods
      end
    end

    module ClassMethods
      def create(code)
        file_cache.fetch(code, expires_in: 1.days) do
          super(code)
        end
      end

      def random_chars
        if cached_codes.length >= RuCaptcha.config.cache_limit
          return cached_codes.sample
        end

        code = super
        cached_codes << code
        code
      end

      def file_cache
        return @file_cache if defined?(@file_cache)

        cache_path = Rails.root.join('tmp', 'cache', 'rucaptcha')
        FileUtils.mkdir_p(cache_path) unless File.exist? cache_path
        @file_cache = ActiveSupport::Cache::FileStore.new(cache_path)
        # clear expired captcha cache files on Process restart
        @file_cache.cleanup
        @file_cache
      end

      def cached_codes
        @cached_codes ||= []
      end
    end
  end
end
