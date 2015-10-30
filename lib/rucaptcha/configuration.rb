module RuCaptcha
  class Configuration
    # Image width, default 150
    attr_accessor :width
    # Image height, default 48
    attr_accessor :height
    # Number of chars, default 4
    attr_accessor :len
    # implode, default 0.4
    attr_accessor :implode
    # Number of Captcha codes limit
    # set 0 to disable limit and file cache, default: 100
    attr_accessor :cache_limit
  end
end
