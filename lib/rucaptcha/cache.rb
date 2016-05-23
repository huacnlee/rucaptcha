require 'fileutils'

module RuCaptcha
  # File Cache
  module Cache
    extend ActiveSupport::Concern

    included do
      class << self
        alias_method_chain :create, :cache
        alias_method_chain :random_chars, :cache
      end
    end

    module ClassMethods
      def create_with_cache(code)
        cache.fetch(code) do
          create_without_cache(code)
        end
      end

      def random_chars_with_cache
        if cached_codes.length >= RuCaptcha.config.cache_limit
          return cached_codes.sample
        else
          code = random_chars_without_cache
          cached_codes << code
          return code
        end
      end

      def cache
        return @cache if defined?(@cache)

        cache_path = Rails.root.join('tmp', 'cache', 'rucaptcha')
        FileUtils.mkdir_p(cache_path) unless File.exist? cache_path
        @cache = ActiveSupport::Cache::FileStore.new(cache_path)
        @cache.clear
        @cache
      end

      def cached_codes
        @cached_codes ||= []
      end
    end
  end
end
