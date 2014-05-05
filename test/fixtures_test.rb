require "minitest/autorun"
require "active_support/core_ext/numeric/time"
require "opendmm"

I18n.enforce_available_locales = false

class FixtureTest < Minitest::Test
  def assert_equal(expected, actual)
    case expected
    when Hash
      assert actual.instance_of?(Hash), "#{expected} expected but non-hash value #{actual} given"
      expected.each do |k, v|
        assert_equal v, actual[k]
      end
    when Array
      assert actual.instance_of?(Array), "#{expected} expected but non-array value #{actual} given"
      assert (expected - actual).empty?, "#{expected} not included in #{actual}"
    else
      super(expected, actual)
    end
  end
end

Dir[File.dirname(__FILE__) + '/fixtures/*.rb'].each do |file|
  name = File.basename(file, ".rb")
  require_relative "fixtures/#{name}"
  eval <<-TESTCASE

class FixtureTest
  def test_#{name.downcase}
    Fixture::#{name.upcase}.each do |name, details|
      assert_equal details, OpenDMM.search(name)
    end
  end
end

TESTCASE
end
