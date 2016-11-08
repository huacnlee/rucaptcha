lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'rucaptcha/version'

Gem::Specification.new do |s|
  s.name                  = 'rucaptcha'
  s.version               = RuCaptcha::VERSION
  s.authors               = 'Jason Lee'
  s.email                 = 'huacnlee@gmail.com'
  s.files                 = Dir.glob('lib/**/*') + Dir.glob('app/**/*') + Dir.glob('config/**/*') + %w(README.md CHANGELOG.md)
  s.homepage              = 'https://github.com/huacnlee/rucaptcha'
  s.require_paths         = ['lib']
  s.summary               = 'This is a Captcha gem for Rails Application. It run ImageMagick command to draw Captcha image.'
  s.license               = "MIT"
  s.required_ruby_version = ">= 2.0.0"

  s.add_dependency 'railties', '>= 3.2'
end
