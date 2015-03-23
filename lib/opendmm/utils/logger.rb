require 'logger'

module OpenDMM
  LOGGER = Logger.new STDERR
  LOGGER.level = Logger::FATAL
end