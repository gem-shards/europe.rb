require 'open-uri'
require 'nokogiri'

# Europe Gem
module Europe
  # currency
  module Currency
    # exchange rates
    module ExchangeRates
      EXCHANGE_URL = 'http://www.ecb.europa.eu/stats/' \
                     'eurofxref/eurofxref-daily.xml'.freeze
      def self.retrieve
        extract_rates(Nokogiri::XML(open(EXCHANGE_URL)))
      end

      def self.extract_rates(doc)
        rates = { date: Date.parse(doc.css('Cube Cube').first['time']),
                  rates: {} }
        doc.css('Cube Cube Cube').each do |rate|
          rates[:rates][rate.xpath('@currency').text.to_sym] =
            rate.xpath('@rate').text.to_f
        end
        rates
      end
    end
  end
end
