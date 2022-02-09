New release please visit:

https://github.com/huacnlee/rucaptcha/releases

## 2.5.5

- Improved image for thicker interference lines.
- Add more colors.

## 2.5.4

- Fix: rucaptcha input maxlength attribute with config value.

## 2.5.3

- Fix session invalid warning, only for development env;

## 2.5.2

- Fix session.id error with upgrade Rails 6.0.2.1 or Rack 2.0.8 (#84)

## 2.5.1

- Fix invalid module name error. (#78)

## 2.5.0

- Support click captcha image to refresh new one by default.
- Use simple tag helper generate captcha img html, for avoid asset_host (#73).

## 2.4.0

- Add skip_cache_store_check configuration. (#63)
- Fix for generate captcha with relative path, not url. (#58)

## 2.3.2

- Change Yellow and Green colors to Pink and Deep Purple to pass WCAG 2.0's contrast test. (#70)

## 2.3.1

- Fix #67 a y chars will invalid error (only in 2.3.0).

## 2.3.0

- Add `config.outline` for use outline style.
- Reduce colors down to 5 (red, blue, green, yellow and black).

## 2.2.0

- Add option `config.length` for support change number chars. (#57)
- Add option `config.strikethrough` for enable or disable strikethrough. (#57)

## 2.1.3

- Windows support fixed with `send_data` method. (#45)

## 2.1.2

- Do not change captcha when `HEAD /rucaptcha`.

## 2.1.1

- Mount engine use `prepend` method to get high priority in config/routes.rb.

## 2.1.0

- Mount Router by default, not need config now.

  > IMPORTANT: Wen you upgrade this version, you need remove `mount RuCaptcha::Engine` line from your `config/routes.rb`

- Default use [:file_store, 'tmp/cache/rucaptcha/session'] as RuCaptcha.config.cache_store, now it can work without any configurations.

> NOTE: But you still need care about `config.cache_store` to setup on a right way.

## 2.0.3

- Use `ActiveSupport.on_load` to extend ActionController and ActionView.

## 2.0.1

- Fix `/rucaptcha` path issue when `config.action_controller.asset_host` has setup with CDN url.

## 2.0.0

_Break Changes!_

WARNING!: This version have so many break changes!

- Use C ext instead of ImageMagick, now it's no dependencies!
- New captcha style.
- Remove `len`, `font_size`, `cache_limit` config key, no support now.
- Output `GIF` format.
