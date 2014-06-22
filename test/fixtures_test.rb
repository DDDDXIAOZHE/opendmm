require 'minitest/autorun'
require 'active_support/core_ext/hash/keys'
require 'active_support/core_ext/string/inflections'
require 'active_support/json'
require 'hashdiff'
require 'opendmm'

I18n.enforce_available_locales = false

class FixtureTest < Minitest::Test
  def load_product(path)
    json = File.read(path)
    product = ActiveSupport::JSON.decode(json).symbolize_keys
    product[:release_date] = Date.parse(product[:release_date]) if product[:release_date]
    product[:__extra].try(:symbolize_keys!)
    product
  end

  def assert_has_basic_keys(product)
    %i(code title thumbnail_image cover_image page).each do |key|
      assert product[key], "Key #{key} should not be absent"
    end
  end

  def assert_no_unknown_keys(product)
    known_keys = {
      actresses:       Array,
      actress_types:   Array,
      boobs:           String,
      brand:           String,
      categories:      Array,
      code:            String,
      cover_image:     String,
      description:     String,
      directors:       Array,
      genres:          Array,
      label:           String,
      maker:           String,
      movie_length:    Fixnum,
      page:            String,
      release_date:    Date,
      sample_images:   Array,
      scenes:          Array,
      series:          String,
      subtitle:        String,
      theme:           String,
      thumbnail_image: String,
      title:           String,
      __extra:         Hash,
    }
    product.each do |key, value|
      klass = known_keys[key]
      assert klass, "Unknown key: #{key}"
      assert_equal klass, value.class, "Value #{key} should be a #{known_keys[key]}, while #{value} provided" if value
    end
  end
end

Dir[File.dirname(__FILE__) + '/fixtures/*.json'].each do |path|
  name = File.basename(path, '.json')
  eval <<-TESTCASE

class FixtureTest
  def test_#{name.parameterize.underscore}
    expected = load_product('#{path}')
    actual = OpenDMM.search('#{name}')
    assert_has_basic_keys(actual)
    assert_no_unknown_keys(actual)
    assert_equal expected, actual, HashDiff.diff(expected, actual)
  end
end

TESTCASE
end
