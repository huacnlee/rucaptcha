lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "rucaptcha/version"

Gem::Specification.new do |s|
  s.name = 'rucaptcha'
  s.version = RuCaptcha::VERSION
  s.authors = ['Jason Lee']
  s.email = 'huacnlee@gmail.com'
  s.files        = Dir.glob("lib/**/*") + Dir.glob("app/**/*") + Dir.glob("config/**/*") + %w(README.md CHANGELOG.md)
  s.homepage = 'https://github.com/huacnlee/rucaptcha'
  s.require_paths = ['lib']
  s.summary = 'This is a Captcha gem for Rails Application. It run ImageMagick command to draw Captcha image.'


  s.add_development_dependency 'rake'
  s.add_development_dependency 'rails'
  s.add_development_dependency 'rspec', '>= 3.3.0'
end
