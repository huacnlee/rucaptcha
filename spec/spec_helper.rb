require 'rubygems'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'rucaptcha'
require 'rtesseract'

tmp_path = File.join(File.dirname(__FILE__), '../tmp')
if !File.exists?(tmp_path)
  Dir.mkdir(tmp_path)
end

module Rails
  class << self
    def root
      Pathname.new(File.join(File.dirname(__FILE__), '..'))
    end
  end
end

RuCaptcha.configure do
  self.len = 2
  self.height = 33
  self.font_size = 48
  self.implode = 0.111
end
