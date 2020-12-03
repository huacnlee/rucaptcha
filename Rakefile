require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rake/extensiontask'

Rake::ExtensionTask.new "rucaptcha" do |ext|
  ext.lib_dir = "lib/rucaptcha"
end

RSpec::Core::RakeTask.new(:spec)
task default: :spec


task :preview do
  require 'rucaptcha'

  res = RuCaptcha.create(1, 5, 1, 0)
  $stderr.puts res[0]
  puts res[1]
end

task :memory do
  require 'rucaptcha'
  puts "Starting to profile memory..."
  b = {}
  puts "Before => #{GC.stat(b)[:heap_live_slots] }"
  count = 1_000_000
  step = (count / 100).to_i
  count.times do |i|
    res = RuCaptcha.generate()
    if i % step == 0
      puts GC.stat(b)[:heap_live_slots] 
    end
  end

  puts "Final => #{GC.stat(b)[:heap_live_slots]}"
  puts GC.start
  puts "After GC => #{GC.stat(b)[:heap_live_slots]}"
end