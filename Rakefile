require 'bundler/gem_tasks'
require 'rake/testtask'

STDOUT.sync = true

Rake::TestTask.new do |t|
  t.pattern = 'test/*_test.rb'
end

task :test => :install
