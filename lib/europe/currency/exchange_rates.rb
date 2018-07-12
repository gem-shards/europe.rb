require 'rexml/document'
require 'net/http'
require 'date'

# Europe Gem
module Europe
  # currency
  module Currency
    # exchange rates
    module ExchangeRates
      EXCHANGE_URL = 'https://www.floatrates.com/daily/eur.xml'.freeze

      def self.retrieve
        resp = Net::HTTP.get_response(URI.parse(EXCHANGE_URL))
        resp.code.to_i == 200 ? extract_rates(resp.body) : :failed
      end

      def self.extract_rates(doc)
        xml = REXML::Document.new(doc)

        rates = { date: Date.parse(xml.elements.first.elements[7].text),
                  rates: {} }

        filter_rates(xml, rates)
      end

      def self.filter_rates(xml, rates)
        xml.elements.each('channel/item') do |item|
          rates[:rates][item[13].text.to_sym] = item[17].text.delete(',').to_f
        end
        rates
      end
    end
  end
end
