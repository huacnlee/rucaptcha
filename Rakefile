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

  res = RuCaptcha.create(1, 3, 1)
  puts res[1]
end
