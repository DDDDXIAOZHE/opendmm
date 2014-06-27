require 'bundler/gem_tasks'
require 'rake/testtask'
require 'json'
require 'opendmm'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end

namespace :fixture do
  desc 'Generate a fixture'
  task :generate, [:id] => :install do |t, args|
    fixture = OpenDMM.search(args[:id])
    if fixture.blank?
      puts "#{args[:id]} not found"
      next
    end
    File.open(File.join(File.dirname(__FILE__) + "/test/fixtures/#{args[:id]}.json"), 'w') do |file|
      puts "Generating #{args[:id]}.json"
      file.puts JSON.pretty_generate(fixture)
    end
  end

  desc 'Regenerate all fixtures'
  task :regenerate => :install do
    Dir[File.dirname(__FILE__) + '/test/fixtures/*.json'].each do |path|
      File.open(path, 'w') do |file|
        id = File.basename(path, '.json')
        puts "Generating #{id}.json"
        file.puts JSON.pretty_generate(OpenDMM.search(id))
      end
    end
  end
end

namespace :maker do
  desc "Generate a maker"
  task :generate, [:name] do |t, args|
    File.open(File.join(File.dirname(__FILE__) + "/lib/opendmm/makers/#{args[:name].underscore}.rb"), 'w') do |file|
      puts "Generating #{args[:name].underscore}.rb"
      file.puts <<-CODE
module OpenDMM
  module Maker
    module #{args[:name].underscore.classify}
      include Maker

      module Site
        include HTTParty
        base_uri 'example.com'

        def self.item(name)
          case name
          when /^(EXAM)-?(\\d{3})$/i
            get("/#\{$1.downcase\}#\{$2\}")
          end
        end
      end

      module Parser
        def self.parse(content)
          page_uri = content.request.last_uri
          html = Nokogiri::HTML(content)
          return {
            page:            page_uri.to_s,
          }
        end
      end
    end
  end
end
CODE
    end
  end
end

task :test => :install
task :default => :test
