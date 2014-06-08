require "minitest/autorun"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/string/inflections"
require "active_support/json"
require "opendmm"

I18n.enforce_available_locales = false

class FixtureTest < Minitest::Test
  def load_product(path)
    json = File.read(path)
    product = ActiveSupport::JSON.decode(json).symbolize_keys
    product[:release_date] = Date.parse(product[:release_date]) if product[:release_date]
    if product[:actresses]
      product[:actresses].each do |name, actress|
        actress.symbolize_keys! if actress
      end
    end
    product
  end
end

Dir[File.dirname(__FILE__) + '/fixtures/*.json'].each do |path|
  name = File.basename(path, ".json")
  eval <<-TESTCASE

class FixtureTest
  def test_#{name.underscore}
    expected = load_product("#{path}")
    actual = OpenDMM.search("#{name}")
    assert_equal expected, actual
  end
end

TESTCASE
end
