require "minitest/autorun"
require "opendmm"

module FixtureTest
  def test_fixtures
    @fixtures.each do |name, details|
      assert_equal_hash(details, OpenDMM.search(name))
    end
  end

  def assert_equal_array(expected, actual)
    assert actual.instance_of?(Array), "#{expected} expected but non-array value #{actual} given"
    assert (expected - actual).empty?, "#{expected} not included in #{actual}"
  end

  def assert_equal_hash(expected, actual)
    assert actual.instance_of?(Hash), "#{expected} expected but non-hash value #{actual} given"
    expected.each do |k, v|
      assert actual.include?(k), "#{actual} doesn't have key #{k}"
      case v
      when Hash
        assert_equal_hash(v, actual[k])
      when Array
        assert_equal_array(v, actual[k])
      else
        assert_equal v, actual[k]
      end
    end
    true
  end
end
