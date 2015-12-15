require 'europe/vat/rates'
require 'savon'

# Europe Gem
module Europe
  # VAT
  module Vat
    WSDL = 'http://ec.europa.eu/taxation_customs/' \
           'vies/checkVatService.wsdl'
    NS = 'urn:ec.europa.eu:taxud:vies:services:checkVat:types'
    def self.validate(country_code, number)
      response = send_request(country_code, number)
      return :failed unless response.success?
      response.body[:check_vat_response].tap { |x| x.delete(:@xmlns) }
    rescue Savon::SOAPFault => fault
      return :timeout \
        if fault.to_hash[:fault][:faultstring] == 'SERVER_BUSY'
      :fault
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
