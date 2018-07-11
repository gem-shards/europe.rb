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

        data = resp.scan(%r{\<tbody\>(.*)\<\/tbody\>}m).first.first.strip
        xml = REXML::Document.new("<root>#{data}</root>")
        xml.first.elements.each('tr') do |result|
          next if result[3].nil?
          rates = filter_rate(result, rates)
        end
        rates
      end

      def self.filter_rate(result, rates)
        country = result[3].text
        rate = result[5].text
        rates[country.to_sym] = rate.to_f if country
        rates
      end

      def self.fetch_rates
        resp = Net::HTTP.get_response(URI.parse(RATES_URL))
        resp.code.to_i == 200 ? resp.body : :failed
      end
    end
  end
end
