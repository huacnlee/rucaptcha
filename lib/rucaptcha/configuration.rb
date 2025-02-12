module RuCaptcha
  class Configuration
    # Store Captcha code where, this config more like Rails config.cache_store
    # default: Rails application config.cache_store
    attr_accessor :cache_store
    # rucaptcha expire time, default 2 minutes
    attr_accessor :expires_in
    # Chars length: default 5, allows: [3..7]
    attr_accessor :length
    # Hard mode, default: 5, allows: [1..10]
    attr_accessor :difficulty
    # Enable or disable strikethrough lines on captcha image, default: true
    attr_accessor :line
    # Enable or disable noise on captcha image, default: false
    attr_accessor :noise
    # Enable or disable circle background on captcha image, default: true
    attr_accessor :circle
    # Image format allow: ['jpeg', 'png', 'webp'], default: 'png'
    attr_accessor :format
    # skip_cache_store_check, default: false
    attr_accessor :skip_cache_store_check
    # custom rucaptcha mount path， default： '/rucaptcha'
    attr_accessor :mount_path
    # Enable or disable case sensitive, default: false
    attr_accessor :case_sensitive
  end
end
