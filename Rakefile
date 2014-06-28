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
    File.open(File.join(File.dirname(__FILE__) + "/test/maker_fixtures/#{args[:id]}.json"), 'w') do |file|
      puts "Generating #{args[:id]}.json"
      file.puts JSON.pretty_generate(fixture)
    end
  end

  desc 'Regenerate all fixtures'
  task :regenerate => :install do
    Dir[File.dirname(__FILE__) + '/test/maker_fixtures/*.json'].each do |path|
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
base_uri 'example.com'

register_product(
  /^(EXAM)-?(\d{3})$/i,
  '#{$1.downcase}#{$2}',
)

private

def self.parse_product_html(html)
  {
  #   actresses:       Array
  #   actress_types:   Array
  #   boobs:           String
  #   brand:           String
  #   categories:      Array
  #   code:            String
  #   cover_image:     String
  #   description:     String
  #   directors:       Array
  #   genres:          Array
  #   label:           String
  #   maker:           String
  #   movie_length:    String
  #   page:            String
  #   release_date:    String
  #   sample_images:   Array
  #   scenes:          Array
  #   series:          String
  #   subtitle:        String
  #   theme:           String
  #   thumbnail_image: String
  #   title:           String
  #   __extra:         Hash
  }
end

CODE
    end
  end
end

task :test => :install
task :default => :test
