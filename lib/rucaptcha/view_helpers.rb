module RuCaptcha
  module ViewHelpers
    def rucaptcha_input_tag(opts = {})
      opts[:name]           = '_rucaptcha'
      opts[:type]           = 'text'
      opts[:autocorrect]    = 'off'
      opts[:autocapitalize] = 'off'
      opts[:pattern]        = '[a-zA-Z]*'
      opts[:autocomplete]   = 'off'
      opts[:maxlength] ||= 5
      tag(:input, opts)
    end

    def rucaptcha_image_tag(opts = {})
      opts[:class] = opts[:class] || 'rucaptcha-image'
      opts[:src] = ru_captcha.root_path
      opts[:onclick] = "this.src = '#{ru_captcha.root_path}?t=' + Date.now();"
      tag(:img, opts)
    end
  end
end
