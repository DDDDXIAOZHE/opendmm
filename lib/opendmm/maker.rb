require 'opendmm/site'

module OpenDMM
  module Maker
    @@makers = Array.new

    def self.search(name)
      @@makers.each do |maker|
        result = maker.product(name)
        return result if result
      end
      nil
    end
  end
end

Dir[File.dirname(__FILE__) + '/makers/*.rb'].each do |file|
  module_name = File.basename(file, '.rb').camelize
  eval <<-MAKER

module OpenDMM
  module Maker
    module #{module_name}
      include Site
      #{File.read(file)}
    end

    @@makers << #{module_name}
  end
end

MAKER
end
