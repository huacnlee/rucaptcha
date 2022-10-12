module RuCaptcha
  module ViewHelpers
    def rucaptcha_input_tag(opts = {})
      opts[:name] = "_rucaptcha"
      opts[:type] = "text"
      opts[:autocorrect] = "off"
      opts[:autocapitalize] = "off"
      opts[:pattern] = "[a-zA-Z0-9]*"
      opts[:autocomplete] = "off"
      opts[:maxlength] = RuCaptcha.config.length
      tag(:input, opts)
    end

    def rucaptcha_image_tag(opts = {})
      @rucaptcha_image_tag__image_path_in_this_request ||= "#{ru_captcha.root_path}?t=#{Time.now.strftime('%s%L')}"
      opts[:class] = opts[:class] || "rucaptcha-image"
      opts[:src] = @rucaptcha_image_tag__image_path_in_this_request
      opts[:onclick] = "this.src = '#{ru_captcha.root_path}?t=' + Date.now();"
      tag(:img, opts)
    end
  end
end
