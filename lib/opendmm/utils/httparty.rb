require 'httparty'
require 'opendmm/utils/logger'

module OpenDMM
  module HTTParty
    def self.included(klass)
      klass.include ::HTTParty
      klass.follow_redirects false
      klass.default_timeout 10

      klass.extend ClassMethods
    end

    module ClassMethods
      def with_retries(&block)
        attempts ||= 0
        yield
      rescue Errno::ETIMEDOUT, Errno::ECONNREFUSED => e
        LOGGER.warning e
        (attempts += 1) < 5 ? retry : raise
      end

      def get(path, options={}, &block)
        with_retries do
          super(path, options, &block)
        end
      end
    end
  end
end
