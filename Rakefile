require "bundler/gem_tasks"
require "rake/testtask"
require "json"
require "opendmm"

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
end

namespace :test do
  desc "Regenerate fixtures"
  task :fixture do
    Dir[File.dirname(__FILE__) + '/test/fixtures/*.json'].each do |path|
      File.open(path, "w") do |file|
        id = File.basename(path, ".json")
        puts "Generating #{id}.json"
        file.puts(JSON.pretty_generate(OpenDMM.search(id)))
      end
    end
  end
end

task :test => :install
