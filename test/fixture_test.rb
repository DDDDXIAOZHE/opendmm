require 'active_support/json'
require 'hashdiff'
require 'highline/import'
require 'opendmm'

I18n.enforce_available_locales = false

class FixtureTest
  def load_product(path)
    json = File.read(path)
    product = ActiveSupport::JSON.decode(json).symbolize_keys
    product[:release_date] = Date.parse(product[:release_date]) if product[:release_date]
    product
  end

  def set_to_fix(path)
  end

  def run
    match_count = 0
    fixed_count = 0
    to_fix_count = 0
    to_fix_list = []

    Dir[File.dirname(__FILE__) + "/fixtures/*.json"].each do |path|
      expected = load_product path
      actual = OpenDMM.search(File.basename(path, '.json'))

      if actual == expected
        match_count += 1
        print '.'
        next
      end

      puts "\n\n=== #{path} ==="
      pp HashDiff.diff(expected, actual)
      serious = HighLine.agree("Is it serious? (y/n)", true)

      if serious
        to_fix_count += 1
        to_fix_list << path
      else
        File.open(path, 'w') do |file|
          file.puts JSON.pretty_generate(actual)
        end
        fixed_count += 1
      end
    end

    puts "\n\n"
    puts "#{match_count} matches; #{fixed_count} fixed; #{to_fix_count} to fix:"
    pp to_fix_list
  end
end

FixtureTest.new.run
