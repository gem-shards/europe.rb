module Europe
  module Vat
    # Rates
    module Rates
      RATES_URL = 'https://europa.eu/youreurope/business/' \
                  'vat-customs/buy-sell/vat-rates/index_en.htm'.freeze
      def self.retrieve
        resp = fetch_rates
        return resp if resp == :failed
        extract_rates(resp)
      end

      def self.extract_rates(resp)
        rates = {}
        doc = Nokogiri::XML(resp)
        doc.css('body tbody tr')[2..-1].each do |data|
          key = data.css('td').children[1].text.to_sym
          rates[key] = data.css('td').children[2].text.to_f
        end
        rates
      end

      def self.fetch_rates
        resp = Net::HTTP.get_response(URI.parse(RATES_URL))
        resp.code.to_i == 200 ? resp.body : :failed
      end
    end
  end
end
