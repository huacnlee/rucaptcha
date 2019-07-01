2.5.1
-------

- Fix invalid module name error. (#78)

2.5.0
-------

- Support click captcha image to refresh new one by default.
- Use simple tag helper generate captcha img html, for avoid asset_host (#73).

2.4.0
-------

- Add skip_cache_store_check configuration. (#63)
- Fix for generate captcha with relative path, not url. (#58)

2.3.2
-------

- Change Yellow and Green colors to Pink and Deep Purple to pass WCAG 2.0's contrast test. (#70)

2.3.1
-------

- Fix #67 a y chars will invalid error (only in 2.3.0).

2.3.0
-------

- Add `config.outline` for use outline style.
- Reduce colors down to 5 (red, blue, green, yellow and black).

2.2.0
-----

- Add option `config.length` for support change number chars. (#57)
- Add option `config.strikethrough` for enable or disable strikethrough. (#57)

2.1.3
-----

- Windows support fixed with `send_data` method. (#45)

2.1.2
-----

- Do not change captcha when `HEAD /rucaptcha`.

2.1.1
-----

- Mount engine use `prepend` method to get high priority in config/routes.rb.

2.1.0
-----

- Mount Router by default, not need config now.

  > IMPORTANT: Wen you upgrade this version, you need remove `mount RuCaptcha::Engine` line from your `config/routes.rb`
- Default use [:file_store, 'tmp/cache/rucaptcha/session'] as RuCaptcha.config.cache_store, now it can work without any configurations.

> NOTE: But you still need care about `config.cache_store` to setup on a right way.



2.0.3
-----

- Use `ActiveSupport.on_load` to extend ActionController and ActionView.

2.0.1
-----

- Fix `/rucaptcha` path issue when `config.action_controller.asset_host` has setup with CDN url.

2.0.0
-----

*Break Changes!*

WARNING!: This version have so many break changes!

- Use C ext instead of ImageMagick, now it's no dependencies!
- New captcha style.
- Remove `len`, `font_size`, `cache_limit` config key, no support now.
- Output `GIF` format.

1.2.0
-----

- Add an `:keep_session` option for `verify_rucaptcha?` method to giva a way for let you keep session on verify, if true, RuCaptcha will not delete the captcha code session after validation.

1.1.4
-----

- Fix #35 just give a warning message if not setup a right cache_store, only raise on :null_store.

1.1.2
-----

- Fix #34 rucaptcha.root_url -> root_path, to avoid generate a http url in a https application.
- Fix spec to require Ruby 2.0.0, because there have a `Module#prepend` method called.

1.1.1
-----

- Remove inspect log on verify_rucaptcha

1.1.0
-----

- Add `cache_store` config key to setup a cache store location for RuCaptcha.
- Store captcha in custom cache store.

## Security Notes

- Fix Session replay secure issue that when Rails application use CookieStore.

1.0.0
-----

- Adjust to avoid lighter colors.
- Avoid continuous chars have same color.
- Use same color for each chars in :black_white mode.

0.5.1
-----

- Make sure it will render image when ImageMagick stderr have warning messages. (#26)

0.5.0
-----

- Fix cache with Rails 5.

0.4.5
-----

- Removed `posix-spawn` dependency, used open3 instead (core funciontality), JRuby compatible (#24)

0.4.4
-----

- Remove deprecated `width`, `height` config.
- Delete session key after verify (#23).
- Lighter text color, improve style.

0.4.2
-----

- Fix NoMethodError bug when params[:_rucaptha] is nil.

0.4.1
-----

- Add error message to resource when captcha code expired.

0.4.0
-----

- Add `config.colorize` option, to allow use black text theme.

0.3.3
-----

- Add `config.expires_in` to allow change captcha code expire time.

0.3.2.1
-------

- Add Windows development env support.

0.3.2
-----

- Make better render positions;
- Trim blank space.

0.3.1
-----

- More complex Image render: compact text, strong lines, +/-5 rotate...
- [DEPRECATION] config.width, config.height removed, use config.font_size.
- Fix the render position in difference font sizes.
- Fix input field type, and disable autocorrect, autocapitalize, and limit maxlength with char length;

0.2.5
-----

- Add `session[:_rucaptcha]` expire time, for protect Rails CookieSession Replay Attack.
- Captcha input field disable autocomplete, and set field type as `email` for shown correct keyboard on mobile view.

0.2.3
-----

- It will raise error when call ImageMagick failed.

0.2.2
-----

- Added locale for pt-BR language; @ramirovjr

0.2.1
-----

- Fix issue when cache dir not exist.

0.2.0
-----

- Added file cache, can setup how many images you want generate by `config.cache_limit`,
  RuCaptcha will use cache for next requests.
  When you restart Rails processes it will generate new again and clean the old caches.

0.1.4
-----

- Fix `verify_rucaptcha?` logic in somecase.
- Locales fixed.

0.1.3
-----

- `zh-TW` translate file fixed.
- Use xxx_url to fix bad captcha URL for `config.action_controller.asset_host` enabled case.

0.1.2
-----

- No case sensitive;
- Export config.implode;
- Improve image color and style;
- Don't generate chars in 'l,o,0,1'.
- Render lower case chars on image.

0.1.1
-----

- Include default validation I18n messages (en, zh-CN, zh-TW).

0.1.0
-----

- First release.
