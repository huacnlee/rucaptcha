require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/extensiontask"
require "rubygems/package_task"
require "bundler"

CROSS_PLATFORMS = %w[
  aarch64-linux
  arm64-darwin
  x64-mingw32
  x86_64-darwin
  x86_64-linux
  x86_64-linux-musl
  aarch64-linux-musl
]

spec = Bundler.load_gemspec("rucaptcha.gemspec")

Gem::PackageTask.new(spec).define

Rake::ExtensionTask.new("rucaptcha", spec) do |ext|
  ext.lib_dir = "lib/rucaptcha"
  ext.source_pattern = "*.{rs,toml}"
  ext.cross_compile = true
  ext.cross_platform = CROSS_PLATFORMS
end

RSpec::Core::RakeTask.new(:spec)
task default: :spec

def create_captcha(length = 5, difficulty = 5)
  require "rucaptcha"
  RuCaptchaCore.create(length, difficulty, false, false, false, "png")
end

task :preview do
  require "rucaptcha"
  res = create_captcha()
  warn "-------------------------\n#{res[0]}"
  puts res[1].pack("c*")
end

task :memory do
  require "rucaptcha"
  require "memory_profiler"

  create_captcha()

  report = MemoryProfiler.report do
    1000.times do
      create_captcha()
    end
  end

  GC.start
  report.pretty_print

  puts "------------------------- Result Guide -------------------------"
  puts "If [Total retained] have any bytes, there will have memory leak."
end

task :benchmark do
  require "rucaptcha"
  require "benchmark/ips"

  RuCaptchaCore.create(5, 5, true, true, true, "png")

  Benchmark.ips do |x|
    x.report("Generate image") { RuCaptchaCore.create(5, 5, true, true, true, "png") }
    x.compare!
  end
end
