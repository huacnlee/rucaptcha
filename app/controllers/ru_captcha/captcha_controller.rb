module RuCaptcha
  class CaptchaController < ActionController::Base
    def index
      headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
      headers['Pragma'] = 'no-cache'
      data = generate_rucaptcha
      opts = { disposition: 'inline', type: 'image/gif' }

      if Gem.win_platform?
        send_file data, opts
      else
        send_data data, opts
      end
    end
  end
end
