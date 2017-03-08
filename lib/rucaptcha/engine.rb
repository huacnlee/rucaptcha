module RuCaptcha
  class Engine < ::Rails::Engine
    isolate_namespace RuCaptcha

    initializer 'rucaptcha.init' do |app|
      # https://github.com/rails/rails/blob/3-2-stable/actionpack/lib/action_dispatch/routing/route_set.rb#L268
      # `app.routes.append` start from Rails 3.2 - 5.0
      app.routes.append do
        mount RuCaptcha::Engine => '/rucaptcha'
      end

      RuCaptcha.check_cache_store!
    end
  end
end
