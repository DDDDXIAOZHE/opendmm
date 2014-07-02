require 'bundler/gem_tasks'
require 'rake/testtask'
require 'json'
require 'opendmm'

Rake::TestTask.new do |t|
  t.pattern = 'test/**/*_test.rb'
end

namespace :fixture do
  desc 'Generate a maker fixture'
  task :maker, [:id] => :install do |t, args|
    generate(args[:id], 'maker')
  end

  desc 'Generate a search engine fixture'
  task :search_engine, [:id, :name] => :install do |t, args|
    generate(args[:id], args[:name])
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

  private

  def generate(id, category)
    fixture = OpenDMM.search(id)
    if fixture.blank?
      puts "#{id} not found"
      return
    end
    FileUtils.mkpath File.dirname(__FILE__) + "/test/#{category}_fixtures/"
    File.open(File.dirname(__FILE__) + "/test/#{category}_fixtures/#{id}.json", 'w') do |file|
      puts "Generating #{id}.json"
      file.puts JSON.pretty_generate(fixture)
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
  /^(EXAM)-?(\\d{3})$/i,
  '#\{$1.downcase\}#\{$2\}',
)

private

def self.parse_product_html(html)
  {
  # actresses:       Array
  # brand:           String
  # categories:      Array
  # code:            String
  # cover_image:     String
  # description:     String
  # directors:       Array
  # genres:          Array
  # label:           String
  # maker:           String
  # movie_length:    String
  # page:            String
  # release_date:    String
  # sample_images:   Array
  # scenes:          Array
  # series:          String
  # subtitle:        String
  # theme:           String
  # thumbnail_image: String
  # title:           String
  }
end
CODE
    end
  end
end

namespace :search_engine do
  desc "Generate a search engine"
  task :generate, [:name] do |t, args|
    File.open(File.join(File.dirname(__FILE__) + "/lib/opendmm/search_engines/#{args[:name].underscore}.rb"), 'w') do |file|
      puts "Generating #{args[:name].underscore}.rb"
      file.puts <<-CODE
base_uri 'example.com'

def self.search_url(name)
  "#{CGI::escape(name)}"
end

def self.product_url(name)
  search_page = get_with_retry search_url(name)
  return nil unless search_page
  search_html = Utils.html_in_utf8 search_page
  first_result = search_html.at_css('CHANGEME')
  first_result['href'] if first_result
end

private

def self.parse_product_html(html)
  {
  # actresses:       Array
  # brand:           String
  # categories:      Array
  # code:            String
  # cover_image:     String
  # description:     String
  # directors:       Array
  # genres:          Array
  # label:           String
  # maker:           String
  # movie_length:    String
  # page:            String
  # release_date:    String
  # sample_images:   Array
  # scenes:          Array
  # series:          String
  # subtitle:        String
  # theme:           String
  # thumbnail_image: String
  # title:           String
  }
end
CODE
    end
  end
end

task :test => :install
task :default => :test
