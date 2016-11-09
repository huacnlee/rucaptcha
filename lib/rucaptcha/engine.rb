module RuCaptcha
  class Engine < ::Rails::Engine
    isolate_namespace RuCaptcha

    initializer 'rucaptcha.prepend.cache' do
      # enable cache if cache_limit less than 1
      if RuCaptcha.config.cache_limit >= 1
        RuCaptcha::Captcha.send(:prepend, RuCaptcha::Cache)
      end

      cache_store = RuCaptcha.config.cache_store
      store_name = cache_store.is_a?(Array) ? cache_store.first : cache_store
      if [:memory_store, :null_store, :file_store].include?(store_name)
        msg = "

  RuCaptcha's cache_store requirements are stored across processes and machines,
  such as :mem_cache_store, :redis_store, or other distributed storage.
  But your current set is :#{store_name}.

  Please make config file `config/initializes/rucaptcha.rb` to setup `cache_store`.
  More infomation please read GitHub RuCaptcha README file.

"
        if store_name == :null_store
          raise msg
        else
          puts msg
        end
      end
    end
  end
end
