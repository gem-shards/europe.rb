# frozen_string_literal: true

require 'json'

module Europe
  module Vat
    # Rates
    module Rates
      FALLBACK_RATES = {
        AT: 20.0, BE: 21.0, BG: 20.0, CY: 19.0, CZ: 21.0, DE: 19.0, DK: 25.0, EE: 24.0,
        EL: 24.0, ES: 21.0, FI: 25.5, FR: 20.0, HR: 25.0, HU: 27.0, IE: 23.0,
        IT: 22.0, LT: 21.0, LU: 17.0, LV: 21.0, MT: 18.0, NL: 21.0, PL: 23.0, PT: 23.0,
        RO: 21.0, SE: 25.0, SI: 22.0, SK: 23.0
      }.freeze
      RATES_URL = 'https://raw.githubusercontent.com/benbucksch/eu-vat-rates' \
                  '/refs/heads/master/rates.json'

      COUNTRY_CODE_MAP = { GR: :EL }.freeze

      def self.retrieve
        resp = fetch_rates
        return FALLBACK_RATES if resp.nil?

        extract_rates(resp)
      end

      def self.extract_rates(resp)
        data = JSON.parse(resp)
        rates = {}
        data['rates'].each do |code, info|
          key = COUNTRY_CODE_MAP[code.to_sym] || code.to_sym
          rates[key] = info['standard_rate'].to_f
        end
        rates
      rescue JSON::ParserError
        FALLBACK_RATES
      end

      def self.fetch_rates
        resp = Net::HTTP.get_response(URI.parse(RATES_URL))
        resp.code.to_i == 200 ? resp.body : nil
      end
    end
  end
end
