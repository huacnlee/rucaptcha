require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/extensiontask"

Rake::ExtensionTask.new "rucaptcha" do |ext|
  ext.lib_dir = "lib/rucaptcha"
end

RSpec::Core::RakeTask.new(:spec)
task default: :spec

task :preview do
  require "rucaptcha"

  res = RuCaptcha.create(1, 5, 1, 0)
  warn res[0]
  puts res[1]
end

task :memory do
  require "rucaptcha"
  puts "Starting to profile memory..."
  b = {}
  puts "Before => #{GC.stat(b)[:heap_live_slots]}"
  count = 10_000_000
  step = (count / 100).to_i
  count.times do |i|
    res = RuCaptcha.generate
    print_memory if i % step == 0
  end

  print_memory
  puts GC.start
  puts "After GC"
  print_memory
end

def print_memory
  rss = `ps -eo pid,rss | grep #{Process.pid} | awk '{print $2}'`.to_i
  puts "rss: #{rss} live objects #{GC.stat[:heap_live_slots]}, total allocated: #{GC.stat[:total_allocated_objects]}"
end
