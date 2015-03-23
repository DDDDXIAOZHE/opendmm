require 'opendmm/engines/jav_library.rb'
require 'opendmm/version.rb'

module OpenDMM
  def self.search(query)
    Engine::JavLibrary.search(query)
  rescue StandardError => e
    LOGGER.error e
    nil
  end
end