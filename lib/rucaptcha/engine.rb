module RuCaptcha
  class Engine < ::Rails::Engine
    isolate_namespace RuCaptcha

    initializer 'rucaptcha.prepend.cache' do
      # enable cache if cache_limit less than 1
      if RuCaptcha.config.cache_limit >= 1
        RuCaptcha::Captcha.send(:prepend, RuCaptcha::Cache)
      end

      if Rails.application.config.session_store.name.match(/CookieStore/)
        puts %(
[RuCaptcha] Your application session has use #{Rails.application.config.session_store}
this may have Session [Replay Attacks] secure issue in RuCaptcha case.
We suggest you change it to backend [:active_record_store, :redis_session_store]
http://guides.rubyonrails.org/security.html#replay-attacks-for-cookiestore-sessions)
        puts ""
      end
    end
  end
end
