module RuCaptcha
  class Engine < ::Rails::Engine
    isolate_namespace RuCaptcha

    initializer 'rucaptcha.init' do |app|
      # https://github.com/rails/rails/blob/3-2-stable/actionpack/lib/action_dispatch/routing/route_set.rb#L268
      # `app.routes.prepend` start from Rails 3.2 - 5.0
      app.routes.prepend do
        mount RuCaptcha::Engine => '/rucaptcha'
      end

      RuCaptcha.check_cache_store! unless RuCaptcha.config.skip_cache_store_check
    end
  end
end
