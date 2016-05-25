module RuCaptcha
  class Engine < ::Rails::Engine
    isolate_namespace RuCaptcha

    initializer 'rucaptcha.prepend.cache' do
      # enable cache if cache_limit less than 1
      if RuCaptcha.config.cache_limit >= 1
        RuCaptcha::Captcha.send(:prepend, RuCaptcha::Cache)
      end
    end
  end
end
