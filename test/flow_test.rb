require 'minitest/autorun'
require 'opendmm'

class FlowTest < MiniTest::Unit::TestCase
  def test_av_entertainments
    assert OpenDMM.search 'MKBD-S40'
  end

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

  def test_one_pondo
    assert OpenDMM.search '1pondo 011111_006'
  end

  def test_tokyo_hot
    assert OpenDMM.search 'Tokyo Hot k0188'
    assert OpenDMM.search 'Tokyo Hot n0900'
  end
end