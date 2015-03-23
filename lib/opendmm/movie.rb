require 'active_support/core_ext/string/starts_ends_with'
require 'active_support/core_ext/object/blank'
require 'opendmm/utils/chronic_duration'
require 'opendmm/utils/date'
require 'opendmm/utils/nokogiri'
require 'uri'

module OpenDMM
  class Movie
    def initialize(page)
      @page = page
      @html = Nokogiri.HTML @page
      @details = Details.new
      @details.page = @page.request.last_uri.to_s
    end

    def details
      LOGGER.debug @details
      @details.to_h
    end

    private

    FIELDS = {
      actresses:    { required: false, type: :Array    },
      code:         { required: true,  type: :String   },
      cover_image:  { required: true,  type: :URI      },
      directors:    { required: false, type: :Array    },
      genres:       { required: false, type: :Array    },
      label:        { required: false, type: :String   },
      maker:        { required: true,  type: :String   },
      movie_length: { required: false, type: :Duration },
      page:         { required: true,  type: :String   },
      release_date: { required: false, type: :Date     },
      title:        { required: true,  type: :String   },
    }

    Details = Struct.new(*FIELDS.keys) do
      def to_h
        Hash.new.tap do |hash|
          FIELDS.each do |key, options|
            value = process_field(self[key], options[:type])
            if value.present?
              hash[key] = value
            else
              raise "Required field #{key} missing" if options[:required]
            end
          end
        end
      end

      private

      def process_field(value, type)
        return unless value.present?
        case type
        when :Array
          raise "Field #{key} not an array: #{value}" unless value.instance_of? Array
          value.map(&:squish).select(&:present?).sort
        when :Date
          Date.parse(value).to_s
        when :Duration
          ChronicDuration.parse(value).to_i
        when :String
          value.to_s.squish
        when :URI
          URI.join(self.page, value).to_s
        else
          raise ArgumentError.new("Unknown value type: #{type}")
        end
      end
    end
  end
end