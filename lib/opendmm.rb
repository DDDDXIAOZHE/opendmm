require "opendmm/version"
require "opendmm/prestige/parser"

module OpenDMM
  def self.search(name)
    Prestige.search(name)
  end
end