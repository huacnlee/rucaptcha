module RuCaptcha
  class Configuration
    # Store Captcha code where, this config more like Rails config.cache_store
    # default: Rails application config.cache_store
    attr_accessor :cache_store
    # rucaptcha expire time, default 2 minutes
    attr_accessor :expires_in
    # Color style, default: :colorful, allows: [:colorful, :black_white]
    attr_accessor :style
    # Chars length: default 5, allows: [3..7]
    attr_accessor :length
    # strikethrough, default: true
    attr_accessor :strikethrough
    # outline style for hard mode, default: false
    attr_accessor :outline
    # skip_cache_store_check, default: false
    attr_accessor :skip_cache_store_check
  end
end
