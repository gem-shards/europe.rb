# frozen_string_literal: true

require 'net/http'
require 'date'

# Europe Gem
module Europe
  # currency
  module Currency
    # exchange rates
    module ExchangeRates
      EXCHANGE_URL = 'https://www.floatrates.com/daily/eur.json'

      def self.retrieve
        resp = Net::HTTP.get_response(URI.parse(EXCHANGE_URL))
        resp.code.to_i == 200 ? extract_rates(resp.body) : :failed
      end

      def self.extract_rates(doc)
        data = JSON.parse(doc)

        rates = { date: Date.parse(data['usd']['date']),
                  rates: {} }

        filter_rates(data, rates)
      rescue JSON::ParserError
        :failed
      end

      def self.filter_rates(data, rates)
        data.each do |currency, object|
          rates[:rates][currency.upcase.to_sym] = object['rate'].to_f
        end
        rates
      end
    end
  end
end
