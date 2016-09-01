require 'base64'
module RuCaptcha
  class CaptchaController < ActionController::Base
    def index
      headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
      headers['Pragma'] = 'no-cache'

      if request.xhr?
        data = Base64.encode64(generate_rucaptcha).gsub("\n", '')
        uri  = "data:image/png;base64,#{data}"
        render json: {data: uri}
      else
        if Gem.win_platform?
          send_file generate_rucaptcha, disposition: 'inline', type: 'image/png'
        else
          send_data generate_rucaptcha, disposition: 'inline', type: 'image/png'
        end
      end
    end
  end
end
