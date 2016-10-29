require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rucaptcha'

tmp_path = File.join(File.dirname(__FILE__), '../tmp')
Dir.mkdir(tmp_path) unless File.exist?(tmp_path)

module Rails
  class << self
    def root
      Pathname.new(File.join(File.dirname(__FILE__), '..'))
    end

    def cache
      @cache ||= ActiveSupport::Cache::MemoryStore.new
    end
  end
end

RuCaptcha.configure do
  self.len       = 2
  self.font_size = 48
  self.implode   = 0.111
  self.cache_store = :mem_cache_store
end
