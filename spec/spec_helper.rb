require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rucaptcha'
require 'rtesseract'

RuCaptcha.configure do
  self.len = 2
  self.width = 123
  self.height = 33
  self.implode = 0.111
end
