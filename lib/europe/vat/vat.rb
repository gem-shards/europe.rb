require 'europe/vat/rates'
require 'europe/vat/format'
require 'savon'

# Europe Gem
module Europe
  # VAT
  module Vat
    WSDL = 'http://ec.europa.eu/taxation_customs/' \
           'vies/checkVatService.wsdl'
    NS = 'urn:ec.europa.eu:taxud:vies:services:checkVat:types'
    def self.validate(number)
      response = send_request(number[0..1], number[2..-1])
      return :failed unless response.success?
      response.body[:check_vat_response].tap { |x| x.delete(:@xmlns) }
    rescue Savon::HTTPError, Savon::SOAPFault
      return :failed
    rescue Timeout::Error
      return :timeout
    end

    def self.charge_vat?(origin_country, number)
      return false if number.nil? || number.empty?
      if origin_country.to_sym == number[0..1].to_sym
        true
      else
        Europe::Countries::COUNTRIES
          .keys.include?(number[0..1].to_sym)
      end
    end

    private

    def self.send_request(country_code, number)
      client = Savon.client(wsdl: WSDL, namespace: NS,
                            open_timeout: 10, read_timeout: 10)

      client.call(:check_vat,
                  message: { countryCode: country_code,
                             vatNumber: number.delete(' ') })
    end
  end
end
