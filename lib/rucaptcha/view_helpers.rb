module RuCaptcha
  module ViewHelpers
    def rucaptcha_input_tag(opts = {})
      opts[:name] = '_rucaptcha'
      opts[:type] = 'email'
      opts[:autocomplete] = 'off'
      tag(:input, opts)
    end

    def rucaptcha_image_tag(opts = {})
      opts[:class] = opts[:class] || 'rucaptcha-image'
      image_tag(ru_captcha.root_url, opts)
    end
  end
end
