require 'bundler/gem_tasks'
require_relative 'test/fixture_manager'

STDOUT.sync = true
# I18n.enforce_available_locales = false

desc 'Test and Fix'
task :fix do
  OpenDMM::FixtureManager.test_all
end

desc 'Test'
task :test do
  OpenDMM::FixtureManager.test_all(true)
end
