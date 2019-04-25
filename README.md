# RuCaptcha

[![Gem Version](https://badge.fury.io/rb/rucaptcha.svg)](https://badge.fury.io/rb/rucaptcha)
[![Build Status](https://travis-ci.org/huacnlee/rucaptcha.svg)](https://travis-ci.org/huacnlee/rucaptcha)

This is a Captcha gem for Rails Applications which generates captcha image by C code.

> NOTE: According to the use of Ruby China, the verification code looks like has a lower than 5% probability of being parsed by OCR and the verification code is cracked. It is recommended that you use the IP rate limit to enhance the protection.
> NOTE: 以 Ruby China 的使用来看，验证码似乎有低于 5% 的概率被 OCR 读取解析导致验证码被破解（我们从日志分析绝大多数是成功的，但偶尔一个成功，配合大量机器攻击，导致注册了很多的垃圾账号），建议你额外配合 IP 频率限制的功能来加强保护。

[中文介绍和使用说明](https://ruby-china.org/topics/27832)

## Example

<img src="https://user-images.githubusercontent.com/5518/49985459-f8492f80-ffa6-11e8-9ef5-8f8f522e4707.png" width="579px" />

## Feature

- No dependencies. No ImageMagick. No RMagick;
- For Rails Application;
- Simple, Easy to use;
- High performance.

## Usage

Put rucaptcha in your `Gemfile`:

```
gem 'rucaptcha'
```

Create `config/initializers/rucaptcha.rb`

```rb
RuCaptcha.configure do
  # Color style, default: :colorful, allows: [:colorful, :black_white]
  # self.style = :colorful
  # Custom captcha code expire time if you need, default: 2 minutes
  # self.expires_in = 120
  # [Requirement / 重要]
  # Store Captcha code where, this config more like Rails config.cache_store
  # default: Read config info from `Rails.application.config.cache_store`
  # But RuCaptcha requirements cache_store not in [:null_store, :memory_store, :file_store]
  # 默认：会从 Rails 配置的 cache_store 里面读取相同的配置信息，并尝试用可以运行的方式，用于存储验证码字符
  # 但如果是 [:null_store, :memory_store, :file_store] 之类的，你可以通过下面的配置项单独给 RuCaptcha 配置 cache_store
  self.cache_store = :mem_cache_store
  # 如果想要 disable cache_store 的 warning，就设置为 true，default false
  # self.skip_cache_store_check = true
  # Chars length, default: 5, allows: [3 - 7]
  # self.length = 5
  # enable/disable Strikethrough.
  # self.strikethrough = true
  # enable/disable Outline style
  # self.outline = false
end
```

RuCaptcha 没有使用 Rails Session 来存储验证码信息，因为 Rails 的默认 Session 是存储在 Cookie 里面，如果验证码存在里面会存在 [Replay attack](https://en.wikipedia.org/wiki/Replay_attack) 漏洞，导致验证码关卡被攻破。

所以我在设计上要求 RuCaptcha 得配置一个可以支持分布式的后端存储方案例如：Memcached 或 Redis 以及其他可以支持分布式的 cache_store 方案。

同时，为了保障易用性，默认会尝试使用 `:file_store` 的方式，将验证码存在应用程序的 `tmp/cache/rucaptcha/session` 目录（但请注意，多机器部署这样是无法正常运作的）。

所以，我建议大家使用的时候，配置上 `cache_store` （详见 [Rails Guides 缓存配置部分](https://ruby-china.github.io/rails-guides/caching_with_rails.html#%E9%85%8D%E7%BD%AE)的文档）到一个 Memcached 或 Redis，这才是最佳实践。

#
(RuCaptha do not use Rails Session to store captcha information. As the default session is stored in Cookie in Rails, there's a [Replay attack](https://en.wikipedia.org/wiki/Replay_attack) bug which may causes capthcha being destroyed if we store captcha in Rails Session.

So in my design I require RuCaptcha to configure a distributed backend storage scheme, such as Memcached, Redis or other cache_store schemes which support distribution.

Meanwhile, for the ease of use, RuCapthca would try to use `:file_store` by default and store the capthca in `tmp/cache/rucaptcha/session` directory (kindly note that it's not working if deploy on multiple machine).

For recommendation, configure the `cache_store`（more details on [Rails Guides Configuration of Cache Stores](http://guides.rubyonrails.org/caching_with_rails.html#configuration)） to Memcached or Redis, that would be the best practice.)

#

Controller `app/controller/account_controller.rb`

When you called `verify_rucaptcha?`, it uses value from `params[:_rucaptcha]` to validate.

```rb
class AccountController < ApplicationController
  def create
    @user = User.new(params[:user])
    if verify_rucaptcha?(@user) && @user.save
      redirect_to root_path, notice: 'Sign up successed.'
    else
      render 'account/new'
    end
  end
end

class ForgotPasswordController < ApplicationController
  def create
    # without any args
    if verify_rucaptcha?
      to_send_email
    else
      redirect_to '/forgot-password', alert: 'Invalid captcha code.'
    end
  end
end
```

> TIP: Sometimes you may need to keep last verified captcha code in session on `verify_rucaptcha?` method call, you can use `keep_session: true`. For example: `verify_rucaptcha? @user, keep_session: true`.

View `app/views/account/new.html.erb`

```erb
<form method="POST">
  ...
  <div class="form-group">
    <%= rucaptcha_input_tag(class: 'form-control', placeholder: 'Input Captcha') %>
    <%= rucaptcha_image_tag(alt: 'Captcha') %>
  </div>
  ...

  <div class="form-group">
    <button type="submit" class="btn btn-primary">Submit</button>
  </div>
</form>
```

And if you are using [Devise](https://github.com/plataformatec/devise), you can read this reference to add validation: [RuCaptcha with Devise](https://github.com/huacnlee/rucaptcha/wiki/Working-with-Devise).

### Write your test skip captcha validation

for RSpec

```rb
describe 'sign up and login', type: :feature do
  before do
    allow_any_instance_of(ActionController::Base).to receive(:verify_rucaptcha?).and_return(true)
  end

  it { ... }
end
```

for MiniTest

```rb
class ActionDispatch::IntegrationTest
  def sign_in(user)
    ActionController::Base.any_instance.stubs(:verify_rucaptcha?).returns(true)
    post user_session_path \
         'user[email]'    => user.email,
         'user[password]' => user.password
  end
end
```

### Invalid message without Devise

When you are using this gem without Devise, you may find out that the invalid message is missing.
For this case, use the trick below to add your i18n invalid message manually.

```rb
if verify_rucaptcha?(@user) && @user.save
  do_whatever_you_want
  redirect_to someplace_you_want
else
  # this is the trick
  @user.errors.add(:base, t('rucaptcha.invalid'))
  render :new
end
```
