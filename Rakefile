require "bundler/gem_tasks"
require "rake/testtask"
require "json"
require "opendmm"

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

namespace :fixture do
  desc "Generate a fixture"
  task :generate, [:id] do |t, args|
    File.open(File.join(File.dirname(__FILE__) + "/test/fixtures/#{args[:id]}.json"), "w") do |file|
      puts "Generating #{args[:id]}.json"
      file.puts JSON.pretty_generate(OpenDMM.search(args[:id]))
    end
  end

  desc "Regenerate all fixtures"
  task :regenerate do
    Dir[File.dirname(__FILE__) + '/test/fixtures/*.json'].each do |path|
      File.open(path, "w") do |file|
        id = File.basename(path, ".json")
        puts "Generating #{id}.json"
        file.puts JSON.pretty_generate(OpenDMM.search(id))
      end
    end
  end
end

task :test => :install
