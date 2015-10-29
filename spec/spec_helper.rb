require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rucaptcha'
require 'rtesseract'

tmp_path = File.join(File.dirname(__FILE__), '../tmp')
if !File.exists?(tmp_path)
  Dir.mkdir(tmp_path)
end

RuCaptcha.configure do
  self.len = 2
  self.width = 123
  self.height = 33
  self.implode = 0.111
end
