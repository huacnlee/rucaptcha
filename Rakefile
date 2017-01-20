require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'rake/extensiontask'

Rake::ExtensionTask.new "rucaptcha" do |ext|
  ext.lib_dir = "lib/rucaptcha"
end

RSpec::Core::RakeTask.new(:spec)
task default: :spec
