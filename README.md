# RuCaptcha

[![Gem Version](https://badge.fury.io/rb/rucaptcha.svg)](https://badge.fury.io/rb/rucaptcha)

This is a Captcha gem for Rails Applications. It runs an ImageMagick command to draw Captcha image - so it has NO performance issues or memory leak issues.

**There is NO: RMagick**

Idea by: https://ruby-china.org/topics/20558#reply4

[中文介绍和使用说明](https://ruby-china.org/topics/27832)

### Requirements

- ImageMagick

### Example

![rucaptcha1](https://cloud.githubusercontent.com/assets/5518/10726119/a844dfce-7c0b-11e5-99c3-a818f3ef3dd2.png) ![rucaptcha2](https://cloud.githubusercontent.com/assets/5518/10747608/2f2f5f10-7c92-11e5-860b-914db5695a57.png) ![rucaptcha3](https://cloud.githubusercontent.com/assets/5518/10747609/2f5bbac4-7c92-11e5-8192-4aa5dfb025b7.png) ![rucaptcha4](https://cloud.githubusercontent.com/assets/5518/10747611/2f7c6a12-7c92-11e5-8730-de7295b36dd6.png) ![rucaptcha5](https://cloud.githubusercontent.com/assets/5518/10747610/2f7a9d86-7c92-11e5-911a-44596c9aeef5.png)



### Usage

Put rucaptcha in your `Gemfile`:

```
gem 'rucaptcha'
```

Create `config/initializes/rucaptcha.rb`

```rb
RuCaptcha.configure do
  # Number of chars, default: 4
  self.len = 4
  # Image width, default: 180
  self.width = 180
  # Image height, default: 48
  self.height = 48
end
```

Edit `config/routes.rb`, add follow line:

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

## Test skip captcha validation

```rb
describe 'sign up and login', type: :feature do
  before do
    allow_any_instance_of(ActionController::Base).to receive(:verify_rucaptcha?).and_return(true)
  end

  it { ... }
end
```

## TODO

- Use [rtesseract](https://github.com/dannnylo/rtesseract) to test OCR.

