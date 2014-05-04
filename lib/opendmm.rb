require "opendmm/version"
require "opendmm/prestige"
require "opendmm/ako3"

module OpenDMM
  def self.search(name)
    Prestige.search(name) || Ako3.search(name)
  end
end