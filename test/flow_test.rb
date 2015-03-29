require 'minitest/autorun'
require 'opendmm'

class FlowTest < MiniTest::Unit::TestCase
  def test_carib
    assert OpenDMM.search 'Carib 021511-620'
  end

  def test_caribpr
    assert OpenDMM.search 'Caribpr 082914_940'
  end

  def test_heyzo
    assert OpenDMM.search 'Heyzo 0822'
  end

  def test_jav_library
    assert OpenDMM.search 'ABP-036'
  end
end