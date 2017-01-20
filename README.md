# RuCaptcha

[![Gem Version](https://badge.fury.io/rb/rucaptcha.svg)](https://badge.fury.io/rb/rucaptcha)
[![Build Status](https://travis-ci.org/huacnlee/rucaptcha.svg)](https://travis-ci.org/huacnlee/rucaptcha)
[![Code Climate](https://codeclimate.com/github/huacnlee/rucaptcha/badges/gpa.svg)](https://codeclimate.com/github/huacnlee/rucaptcha)

This is a Captcha gem for Rails Applications. It drawing captcha image with C extension.

## Example

![rucaptcha0](https://cloud.githubusercontent.com/assets/5518/22144000/22993ea2-df37-11e6-8f67-c32b4394e7a2.gif) ![rucaptcha1](https://cloud.githubusercontent.com/assets/5518/22144499/e831f004-df38-11e6-8cd0-2b47bfab3935.gif) ![rucaptcha2](https://cloud.githubusercontent.com/assets/5518/22144500/e83442aa-df38-11e6-8b98-35c90cd8bad3.gif)

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

> TIP: Sometime you may need keep last verified captcha code in session on `verify_rucaptcha?` method call, you can use `keep_session: true`. For example: ` Verify_rucaptcha? (@user, keep_session: true) `.

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
