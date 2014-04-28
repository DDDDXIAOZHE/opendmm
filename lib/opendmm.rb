require 'opendmm/version'
require 'opendmm/prestige'

module OpenDMM
  def self.search(name)
    Prestige.search(name)
  end
end