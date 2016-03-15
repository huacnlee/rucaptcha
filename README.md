# RuCaptcha

[![Gem Version](https://badge.fury.io/rb/rucaptcha.svg)](https://badge.fury.io/rb/rucaptcha)
[![Build Status](https://travis-ci.org/huacnlee/rucaptcha.svg)](https://travis-ci.org/huacnlee/rucaptcha)

This is a Captcha gem for Rails Applications. It runs an ImageMagick command to draw Captcha image - so it has NO performance issues or memory leak issues.

**There is NO: RMagick**

Idea by: https://ruby-china.org/topics/20558#reply4

[中文介绍和使用说明](https://ruby-china.org/topics/27832)


## Feature

- Only need `ImageMagick`, No `RMagick`, No `mini_magick`;
- For Rails Application;
- Simple, Easy to use;
- File Caching for performance.

## Requirements

- ImageMagick

#### Ubuntu

```
sudo apt-get install imagemagick
```

#### Mac OS X

```bash
brew install imagemagick ghostscript
```

## Example

![captcha8](https://cloud.githubusercontent.com/assets/5518/10965901/f8e17118-83ea-11e5-935d-a17fd6ab8307.png)
![captcha7](https://cloud.githubusercontent.com/assets/5518/10965903/f8e34b5a-83ea-11e5-9f8e-e43fc78347a7.png)
![captcha6](https://cloud.githubusercontent.com/assets/5518/10965902/f8e2f132-83ea-11e5-89f5-b75aedbcfb2f.png)
![captcha5](https://cloud.githubusercontent.com/assets/5518/10965904/f920ec44-83ea-11e5-89d2-3312da0f2bc4.png)
![captcha4](https://cloud.githubusercontent.com/assets/5518/10965905/f92264ac-83ea-11e5-96b0-2e81ee78d073.png)
![captcha3](https://cloud.githubusercontent.com/assets/5518/10965906/f9279652-83ea-11e5-94fa-a9cd2df9beec.png)
![captcha2](https://cloud.githubusercontent.com/assets/5518/10965909/f9623e24-83ea-11e5-8ad3-d4bf94edfe1b.png)
![captcha1](https://cloud.githubusercontent.com/assets/5518/10965908/f95fedfe-83ea-11e5-990b-fdcd2d1a97aa.png)

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

### Write your test skip captcha validation

```rb
describe 'sign up and login', type: :feature do
  before do
    allow_any_instance_of(ActionController::Base).to receive(:verify_rucaptcha?).and_return(true)
  end

  it { ... }
end
```



