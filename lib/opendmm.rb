require 'opendmm/engines/av_entertainments.rb'
require 'opendmm/engines/caribbean.rb'
require 'opendmm/engines/caribbean_pr.rb'
require 'opendmm/engines/heyzo.rb'
require 'opendmm/engines/jav_library.rb'
require 'opendmm/engines/one_pondo.rb'
require 'opendmm/engines/tokyo_hot.rb'
require 'opendmm/version.rb'

module OpenDMM
  def self.search(query)
    [ Engine::Caribbean,
      Engine::CaribbeanPr,
      Engine::Heyzo,
      Engine::OnePondo,
      Engine::TokyoHot,
      Engine::JavLibrary,
      Engine::AvEntertainments,
    ].lazy.map do |engine|
      begin
        engine.search(query)
      rescue StandardError => e
        LOGGER.info e
        nil
      end
    end.find(&:present?)
  end
end