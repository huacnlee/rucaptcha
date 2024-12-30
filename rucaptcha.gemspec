lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require "rucaptcha/version"

Gem::Specification.new do |s|
  s.name = "rucaptcha"
  s.version = RuCaptcha::VERSION
  s.authors = "Jason Lee"
  s.email = "huacnlee@gmail.com"
  s.files = Dir["{lib,app,config}/**/*.{rb,yml}", "ext/**/*.{rs,toml,lock,rb,ttf}"] + %w[README.md Rakefile]
  s.homepage = "https://github.com/huacnlee/rucaptcha"
  s.require_paths = ["lib"]
  s.extensions = %w[ext/rucaptcha/extconf.rb]
  s.summary = "Captcha Gem for Rails, which generates captcha image by Rust."
  s.license = "MIT"
  s.required_ruby_version = ">= 3.1.0"

  s.add_dependency "railties", ">= 3.2"
  s.add_dependency "rb_sys", ">= 0.9.105"
end
