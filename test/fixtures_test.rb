require "minitest/autorun"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/string/inflections"
require "active_support/json"
require "hashdiff"
require "opendmm"

I18n.enforce_available_locales = false

class FixtureTest < Minitest::Test
  def load_product(path)
    json = File.read(path)
    product = ActiveSupport::JSON.decode(json).symbolize_keys
    product[:release_date] = Date.parse(product[:release_date]) if product[:release_date]
    product[:__extra].try(:symbolize_keys!)
    product
  end
end

Dir[File.dirname(__FILE__) + '/fixtures/*.json'].each do |path|
  name = File.basename(path, ".json")
  eval <<-TESTCASE

class FixtureTest
  def test_#{name.parameterize.underscore}
    expected = load_product("#{path}")
    actual = OpenDMM.search("#{name}")
    assert_equal expected, actual, HashDiff.diff(expected, actual)
  end
end

TESTCASE
end
