0.3.0
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
