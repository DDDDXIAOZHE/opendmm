module OpenDMM
  module Maker
    module Arena
      include Maker

      def self.search(name)
        case name
        when /AXDVD-(\d{3})r/i
          return {
            images: {
              cover: "http://www.arena-corp.jp/dvdr1000/axdvd0#{$1}r.jpg",
            },
            maker:      "Arena",
            product_id: name.upcase,
          }
        end
      end
    end
  end
end
