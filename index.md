# RuCaptcha

[![Gem Version](https://badge.fury.io/rb/rucaptcha.svg)](https://badge.fury.io/rb/rucaptcha)
[![Build Status](https://travis-ci.org/huacnlee/rucaptcha.svg)](https://travis-ci.org/huacnlee/rucaptcha)
[![Code Climate](https://codeclimate.com/github/huacnlee/rucaptcha/badges/gpa.svg)](https://codeclimate.com/github/huacnlee/rucaptcha)

This is a Captcha gem for Rails Applications. It drawing captcha image with C code.

## Example

<img src="https://cloud.githubusercontent.com/assets/5518/22151425/e02390c8-df58-11e6-974d-5eb9b1a4e577.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151427/e4939d92-df58-11e6-9754-4a46a86acea8.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151431/e494576e-df58-11e6-9845-a5590904c175.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151432/e495066e-df58-11e6-92b8-38b40b73aba0.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151428/e49404ee-df58-11e6-8e2d-8b17b33a3710.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151430/e4942406-df58-11e6-9ff8-6e2325304b41.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151429/e4941ae2-df58-11e6-8107-757296573b2f.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151433/e4c7c89c-df58-11e6-9853-1ffbb4986962.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151435/e4c97ea8-df58-11e6-8959-b4c78716271d.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151436/e4cc09f2-df58-11e6-965c-673333b33c0d.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151434/e4c87788-df58-11e6-9490-c255aaafce71.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151445/ee35ff66-df58-11e6-8660-a3673ef3f5ee.gif" width="150px" /> <img src="https://cloud.githubusercontent.com/assets/5518/22151446/ee67b074-df58-11e6-9b95-7d53eec21c33.gif" width="150px" />

[中文介绍和使用说明](https://ruby-china.org/topics/27832)

## Feature

- No dependencies. No ImageMagick, No RMagick.
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
  # [Requirement]
  # Store Captcha code where, this config more like Rails config.cache_store
  # default: Rails application config.cache_store
  # But RuCaptcha requirements cache_store not in [:null_store, :memory_store, :file_store]
  self.cache_store = :mem_cache_store
end
```

Edit `config/routes.rb`, add the following code:

```rb
Rails.application.routes.draw do
  ...
  mount RuCaptcha::Engine => "/rucaptcha"
  ...
end
```

Controller `app/controller/account_controller.rb`

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
```

> TIP: Sometime you may need keep last verified captcha code in session on `verify_rucaptcha?` method call, you can use `keep_session: true`. For example: `verify_rucaptcha? @user, keep_session: true`.

View `app/views/account/new.html.erb`

```erb
<form>
  ...
  <div class="form-group">
    <%= rucaptcha_input_tag(class: 'form-control', placeholder: 'Input Captcha') %>
    <%= rucaptcha_image_tag(alt: 'Captcha') %>
  </div>
  ...
</form>
```

And if you are use Devise, you can read this to add validation: [RuCaptcha with Devise](https://github.com/huacnlee/rucaptcha/wiki/Working-with-Devise).

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
