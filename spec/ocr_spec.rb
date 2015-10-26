require 'spec_helper'

describe 'OCR' do
  before do
    @samples = []
    10.times do
      @samples << SecureRandom.hex(2)
    end
    @filenames = []
    @samples.each do |chars|
      fname = File.join(File.dirname(__FILE__), "..", "tmp", "#{chars}.png")
      img = RuCaptcha::Captcha.create(chars)
      File.open(fname, 'w+') do |f|
        f.puts img
      end
      @filenames << fname
    end
  end

  after do
    `rm #{File.join(File.dirname(__FILE__), '../tmp/*.png')}`
  end

  it 'should not read by OCR lib' do
    results = []
    @samples.each do |chars|
      str = RTesseract.new(File.join(File.dirname(__FILE__), "..", "tmp", "#{chars}.png")).to_s
      results << "- Chars: #{chars}, OCR read #{str.strip}"
      expect(chars).not_to eq(str)
    end

    puts %(------------------------\nOCR all results: \n#{results.join("\n")})
  end
end
