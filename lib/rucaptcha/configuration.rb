module RuCaptcha
  class Configuration
    # Store Captcha code where, this config more like Rails config.cache_store
    # default: Rails application config.cache_store
    attr_accessor :cache_store
    # rucaptcha expire time, default 2 minutes
    attr_accessor :expires_in
  end
end
