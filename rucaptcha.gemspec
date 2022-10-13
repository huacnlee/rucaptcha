lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require "rucaptcha/version"

Gem::Specification.new do |s|
  s.name = "rucaptcha"
  s.version = RuCaptcha::VERSION
  s.authors = "Jason Lee"
  s.email = "huacnlee@gmail.com"
  s.files = Dir["lib/**/*.rb", "ext/**/*.{rs,toml,lock,rb}"] + %w[README.md Rakefile]
  s.homepage = "https://github.com/huacnlee/rucaptcha"
  s.require_paths = ["lib"]
  s.extensions = %w[ext/rucaptcha/extconf.rb]
  s.summary = "This is a Captcha gem for Rails Applications. It drawing captcha image with C code so it no dependencies."
  s.license = "MIT"
  s.required_ruby_version = ">= 2.7.0"

  s.add_dependency "railties", ">= 3.2"
  s.add_dependency "rb_sys", ">= 0.9.18"
end
