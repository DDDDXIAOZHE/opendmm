require 'active_support/core_ext/string/starts_ends_with'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/object/inclusion'
require 'opendmm/utils/chronic_duration'
require 'opendmm/utils/date'
require 'opendmm/utils/nokogiri'
require 'uri'

module OpenDMM
  class Movie
    def initialize(query, response)
      @query = query
      @response = response
      @html = Nokogiri.HTML @response
      @details = Details.new
      @details.base_uri = @response.request.last_uri.to_s
      @details.page = @details.base_uri
    end

    def details
      LOGGER.debug @details
      @details.to_h
    rescue StandardError => e
      LOGGER.error e
      nil
    end

    private

    FIELDS = {
      actresses:       { required: false, type: :Array    },
      actress_types:   { required: false, type: :Array    },
      categories:      { required: false, type: :Array    },
      code:            { required: true,  type: :String   },
      cover_image:     { required: true,  type: :URI      },
      description:     { required: false, type: :String   },
      directors:       { required: false, type: :Array    },
      genres:          { required: false, type: :Array    },
      label:           { required: false, type: :String   },
      maker:           { required: true,  type: :String   },
      movie_length:    { required: false, type: :Duration },
      page:            { required: true,  type: :URI      },
      release_date:    { required: false, type: :Date     },
      sample_images:   { required: false, type: :URIArray },
      series:          { required: false, type: :String   },
      tags:            { required: false, type: :Array    },
      thumbnail_image: { required: false, type: :URI      },
      title:           { required: true,  type: :String   },
    }

    Details = Struct.new(*FIELDS.keys, :base_uri) do
      def to_h
        FIELDS.each do |key, options|
          self[key] = process_field(self[key], options[:type])
        end
        normalize_title
        Hash.new.tap do |hash|
          FIELDS.map do |key, options|
            value = self[key]
            if value.present?
              hash[key] = value
            elsif options[:required]
              raise "Required field #{key} missing"
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
          Date.parse(value.squish).to_s
        when :Duration
          ChronicDuration.parse(value.squish).to_i
        when :String
          value.to_s.squish
        when :URI
          URI.join(self.base_uri, value).to_s
        when :URIArray
          raise "Field #{key} not an array: #{value}" unless value.instance_of? Array
          value.map do |uri|
            URI.join(self.base_uri, uri.squish).to_s
          end.sort
        else
          raise ArgumentError.new("Unknown value type: #{type}")
        end
      end

      def normalize_title
        if actresses = self[:actresses]
          pieces = self[:title].squish.split
          while pieces.last.in?(actresses) || pieces.last =~ /-+/
            pieces.pop
          end
          self.title = pieces.join(' ').squish
        end
      end
    end
  end
end