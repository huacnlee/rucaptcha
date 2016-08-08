module RuCaptcha
  module ViewHelpers

    def reload_ajax_tag(img_captcha_selector)
      js = %Q( jQuery.getJSON("/rucaptcha", function(json){ jQuery('#{img_captcha_selector}').attr('src', json.data) }) )
      link_to "Reload!", "javascript:#{js}", type:'button'
    end

    def rucaptcha_input_tag(opts = {})
      opts[:name]           = '_rucaptcha'
      opts[:type]           = 'text'
      opts[:autocorrect]    = 'off'
      opts[:autocapitalize] = 'off'
      opts[:pattern]        = '[0-9a-z]*'
      opts[:maxlength]      = RuCaptcha.config.len
      opts[:autocomplete]   = 'off'
      tag(:input, opts)
    end


    def rucaptcha_image_tag(opts = {})
      opts[:class] = opts[:class] || 'rucaptcha-image'

      if opts.delete(:reload)
        image_tag(ru_captcha.root_url, opts)+
        reload_ajax_tag("##{opts[:id]}"||".#{opts[:class]}")
      else
        image_tag(ru_captcha.root_url, opts)
      end
    end
  end
end
