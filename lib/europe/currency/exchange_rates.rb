require 'rexml/document'
require 'net/http'

# Europe Gem
module Europe
  # currency
  module Currency
    # exchange rates
    module ExchangeRates
      EXCHANGE_URL = 'http://www.ecb.europa.eu/stats/' \
                     'eurofxref/eurofxref-daily.xml'.freeze
      def self.retrieve
        resp = Net::HTTP.get_response(URI.parse(EXCHANGE_URL))
        resp.code.to_i == 200 ? extract_rates(resp.body) : :failed
      end

      def self.extract_rates(doc)
        xml = REXML::Document.new(doc)
        cubes = xml.elements.first.elements[3].elements[1]

        rates = { date: Date.parse(cubes.attributes['time']),
                  rates: {} }

        filter_rates(cubes, rates)
      end

      def self.filter_rates(cubes, rates)
        cubes.elements.each('Cube') do |cube|
          rates[:rates][cube.attributes['currency'].to_sym] =
            cube.attributes['rate'].to_f
        end
        rates
      end
    end
  end
end
