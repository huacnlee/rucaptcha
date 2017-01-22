module RuCaptcha
  module ViewHelpers
    def rucaptcha_input_tag(opts = {})
      opts[:name]           = '_rucaptcha'
      opts[:type]           = 'text'
      opts[:autocorrect]    = 'off'
      opts[:autocapitalize] = 'off'
      opts[:pattern]        = '[a-zA-Z]*'
      opts[:maxlength]      = 5
      opts[:autocomplete]   = 'off'
      tag(:input, opts)
    end

    def rucaptcha_image_tag(opts = {})
      opts[:class] = opts[:class] || 'rucaptcha-image'
      opts[:host] ||= ''
      image_tag(opts[:host]+ru_captcha.root_path, opts)
    end
  end
end
