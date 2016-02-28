require 'spec_helper'
require 'fileutils'
require 'tmpdir'

describe 'OCR' do
  before do
    @tmp_dir = Dir.mktmpdir
    @samples = []
    10.times do
      @samples << SecureRandom.hex(2)
    end
    @filenames = []
    @samples.each do |chars|
      fname = File.join(@tmp_dir, "#{chars}.png")
      img = RuCaptcha::Captcha.create(chars)
      File.open(fname, 'w+') do |f|
        f.puts img
      end
      @filenames << fname
    end
  end

  after do
    FileUtils.rm_f(@tmp_dir)
  end

  it 'should not read by OCR lib' do
    results = []
    @samples.each do |chars|
      str = RTesseract.new(File.join(@tmp_dir, "#{chars}.png"), processor: 'mini_magick').to_s
      results << "- Chars: #{chars}, OCR read #{str.strip}"
      expect(chars).not_to eq(str)
    end

    puts %(\n------------------------\nOCR all results: \n#{results.join("\n")})
  end
end
