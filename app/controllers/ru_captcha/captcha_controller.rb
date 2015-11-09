module RuCaptcha
  class CaptchaController < ActionController::Base
    def index
      headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
      headers['Pragma'] = 'no-cache'

      send_data generate_rucaptcha, disposition: 'inline', type: 'image/png'
    end
  end
end
