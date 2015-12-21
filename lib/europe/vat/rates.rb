require 'net/http'
require 'uri'
require 'nokogiri'

module Europe
  module Vat
    # Rates
    module Rates
      RATES_URL = 'http://ec.europa.eu/taxation_customs/tic/' \
                  'public/vatRates/vatratesSearch.html'
      def self.retrieve
        resp = fetch_rates
        return resp if resp == :failed
        extract_rates(resp)
      end

      private

      def self.extract_country_code(data)
        Europe::Countries::Reversed.generate(:name) \
          [data.css('td').first.text.strip!]
      end

      def self.extract_rate_number(data)
        data.css('td')[1].css('div span').text.tr('%', '').to_f
      end

      def self.extract_rates(resp)
        rates = {}
        doc = Nokogiri::XML(resp)
        doc.css('#national tbody tr')[0..-2].each do |data|
          key = extract_country_code(data)
          rates[key] = extract_rate_number(data)
        end
        rates
      end

      def self.generate_url
        uri = URI.parse(RATES_URL)
        params = 'listOfTypes=Standard&dateFilter=' +
                 Time.new.strftime('%d/%m/%Y')
        [*1..Europe::Countries::COUNTRIES.count].each do |index|
          params += '&listOfMsa=' + (index).to_s
        end
        [uri, params]
      end

      def self.fetch_rates
        uri, params = generate_url
        req = Net::HTTP::Post.new(uri.path)
        req.body = params
        resp = Net::HTTP.start(uri.hostname, uri.port) do |http|
          http.request(req)
        end
        resp.code.to_i == 200 ? resp.body : :failed
      end
    end
  end
end
