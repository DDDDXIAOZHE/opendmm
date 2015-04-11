require 'logger'

module OpenDMM
  LOGGER = Logger.new STDERR
  LOGGER.formatter = proc do |severity, datetime, progname, msg|
    file = caller[4][/.*\/(.*):.*/, 1]
    "[#{severity[0]}, #{datetime}, #{file}]: #{msg}\n"
  end
  LOGGER.level = Logger::FATAL
end