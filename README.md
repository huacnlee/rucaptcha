# RuCaptcha

[![Gem Version](https://badge.fury.io/rb/rucaptcha.svg)](https://badge.fury.io/rb/rucaptcha)
[![Build Status](https://travis-ci.org/huacnlee/rucaptcha.svg)](https://travis-ci.org/huacnlee/rucaptcha)
[![Code Climate](https://codeclimate.com/github/huacnlee/rucaptcha/badges/gpa.svg)](https://codeclimate.com/github/huacnlee/rucaptcha)

This is a Captcha gem for Rails Applications. It runs an ImageMagick command to draw Captcha image - so it has NO performance issues or memory leak issues. **There is NO: RMagick**

## Example

![1](https://cloud.githubusercontent.com/assets/5518/15423974/b186b0d6-1eb2-11e6-9c0e-4cc3a66f32c8.png)
![2](https://cloud.githubusercontent.com/assets/5518/15423975/b1887b6e-1eb2-11e6-895f-5629f82697d3.png)
![3](https://cloud.githubusercontent.com/assets/5518/15423978/b18f08ee-1eb2-11e6-9670-c21dba290e04.png)
![4](https://cloud.githubusercontent.com/assets/5518/15423976/b18b6946-1eb2-11e6-8413-700ded157262.png)
![5](https://cloud.githubusercontent.com/assets/5518/15423977/b18e7c62-1eb2-11e6-96f7-5bd6981d4185.png)
![6](https://cloud.githubusercontent.com/assets/5518/15423979/b19175d4-1eb2-11e6-9417-7d496fb996b4.png)
![7](https://cloud.githubusercontent.com/assets/5518/15423980/b1caf944-1eb2-11e6-862e-78c0a9360b43.png)

Idea by: https://ruby-china.org/topics/20558#reply4

[中文介绍和使用说明](https://ruby-china.org/topics/27832)

## Feature

- Only need `ImageMagick`, No `RMagick`, No `mini_magick`;
- For Rails Application;
- Simple, Easy to use;
- File Caching for performance.

## Requirements

- ImageMagick 6.9+

#### Ubuntu

```
sudo apt-get install imagemagick ghostscript
```

#### Mac OS X

```bash
brew install imagemagick ghostscript
```

## Usage

Put rucaptcha in your `Gemfile`:

```
gem 'rucaptcha'
```

Create `config/initializers/rucaptcha.rb`

```rb
RuCaptcha.configure do
  # Number of chars, default: 4
  self.len = 4
  # Image font size, default: 45
  self.font_size = 45
  # Cache generated images in file store, this is config files limit, default: 100
  # set 0 to disable file cache.
  self.cache_limit = 100
  # Custom captcha code expire time if you need, default: 2 minutes
  # self.expires_in = 120
  # Color style, default: :colorful, allows: [:colorful, :black_white]
  # self.style = :colorful
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
