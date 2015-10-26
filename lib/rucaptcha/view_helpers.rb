module RuCaptcha
  module ViewHelpers
    def rucaptcha_input_tag(opts = {})
      opts[:name] = '_rucaptcha'
      tag(:input, opts)
    end

    def rucaptcha_image_tag(opts = {})
      opts[:class] = opts[:class] || 'rucaptcha-image'
      image_tag(ru_captcha.root_path, opts)
    end
  end
end
