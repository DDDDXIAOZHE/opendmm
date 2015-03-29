require 'active_support/core_ext/numeric/time'
require 'chronic_duration'

module OpenDMM
  module ChronicDuration
    def self.parse(str)
      case str
      when /(\d+)\s*分\s*(\d+)\s*秒/
        return $1.to_i.minutes + $2.to_i.seconds
      when /(\d+)(\s*)分/, /(\d+)(\s*)min/i
        return $1.to_i.minutes
      else
        return ::ChronicDuration.parse(str)
      end
    end
  end
end