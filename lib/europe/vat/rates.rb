# frozen_string_literal: true

require 'rexml/document'

module Europe
  module Vat
    # Rates
    module Rates
      RATES_URL = 'https://ec.europa.eu/taxation_customs/' \
                  'business/vat/telecommunications-broadcasting' \
                  '-electronic-services/vat-rates_en'

      def self.retrieve
        resp = fetch_rates
        return resp if resp == :failed

        extract_rates(resp)
      end

      def self.extract_rates(resp)
        rates = {}

        data = resp.scan(%r{\<tbody\>(.*)\<\/tbody\>}m).first.first.strip
        xml = REXML::Document.new("<root>#{data}</root>")
        xml.first.elements.each('tr') do |result|
          next if result[3].nil?

          rates = filter_rate(result, rates)
        end
        rates
      end

      def self.filter_rate(result, rates)
        country = result[0].text
        rate = result[3].text
        country_code = Europe::Countries::Reversed.generate(:name)[country]
        rates[country_code] = rate.to_f if country_code
        rates
      end

      def self.fetch_rates
        resp = Net::HTTP.get_response(URI.parse(RATES_URL))
        resp.code.to_i == 200 ? resp.body : :failed
      end
    end
  end
end
