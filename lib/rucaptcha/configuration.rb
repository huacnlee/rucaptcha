module RuCaptcha
  class Configuration
    # TODO: remove height, width in 0.3.0
    attr_accessor :height, :width
    # Image font size, default 45
    attr_accessor :font_size
    # Number of chars, default 4
    attr_accessor :len
    # implode, default 0.4
    attr_accessor :implode
    # Number of Captcha codes limit
    # set 0 to disable limit and file cache, default: 100
    attr_accessor :cache_limit
    # Enable colorful style, default: true
    # set false to disable, it will render black color
    attr_accessor :colorize
    # session[:_rucaptcha] expire time, default 2 minutes
    attr_accessor :expires_in
  end
end
