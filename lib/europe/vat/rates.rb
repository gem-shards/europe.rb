# frozen_string_literal: true

require 'rexml/document'

module Europe
  module Vat
    # Rates
    module Rates
      FALLBACK_RATES = {
        AT: 20.0, BE: 21.0, BG: 20.0, CY: 19.0, CZ: 21.0, DE: 19.0, DK: 25.0, EE: 22.0,
        EL: 24.0, ES: 21.0, FI: 25.5, FR: 20.0, HR: 25.0, HU: 27.0, IE: 23.0,
        IT: 22.0, LT: 21.0, LU: 17.0, LV: 21.0, MT: 18.0, NL: 21.0, PL: 23.0, PT: 23.0,
        RO: 19.0, SE: 25.0, SI: 22.0, SK: 23.0
      }.freeze
      RATES_URL = 'https://europa.eu/youreurope/business/taxation/vat' \
                  '/vat-rules-rates/index_en.htm'

      def self.retrieve
        resp = fetch_rates
        return FALLBACK_RATES if resp.nil?

        extract_rates(resp)
      end

      # rubocop:disable Metrics/MethodLength
      def self.extract_rates(resp)
        rates = {}

        begin
          data = resp.scan(%r{\<tbody\>(.*)\<\/tbody\>}m).first.first.strip
        rescue NoMethodError
          return FALLBACK_RATES
        end

        xml = REXML::Document.new("<root>#{data}</root>")
        xml.first.elements.each('tr') do |result|
          next if result[3].nil?

          rates = filter_rate(result, rates || {})
        end
        rates
      end
      # rubocop:enable Metrics/MethodLength

      def self.filter_rate(result, rates)
        return unless result[1].text.size == 2

        country = result[1].text
        rate = result[5].text
        rates[country.to_sym] = rate.to_f if country && rate
        rates
      end

      def self.fetch_rates
        resp = Net::HTTP.get_response(URI.parse(RATES_URL))
        resp.code.to_i == 200 ? resp.body : nil
      end
    end
  end
end
