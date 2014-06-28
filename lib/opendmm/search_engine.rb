require 'opendmm/utils'

Dir[File.dirname(__FILE__) + '/search_engines/*.rb'].each do |file|
  module_name = File.basename(file, '.rb').camelize
  eval <<-ENGINE

module OpenDMM
  module SearchEngine
    module #{module_name}
      include Site
      #{File.read(file)}
      def self.search(name)
        self.product(name)
      end
    end
  end
end

ENGINE
end