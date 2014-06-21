require 'opendmm/version'
require 'opendmm/maker'
require 'opendmm/search_engines/jav_library'

module OpenDMM
  def self.search(name)
    Utils.cleanup(Maker.search(name) || SearchEngine::JavLibrary.search(name))
  end
end