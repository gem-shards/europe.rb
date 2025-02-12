# frozen_string_literal: true

require 'europe/vat/rates'
require 'europe/vat/format'
require 'uri'
require 'net/http'
require 'rexml/document'
require 'date'

# Europe Gem
module Europe
  # VAT
  module Vat
    WSDL = 'http://ec.europa.eu/taxation_customs/vies/' \
           'services/checkVatService'
    HEADERS = {
      'Content-Type' => 'text/xml;charset=UTF-8',
      'SOAPAction' => ''
    }.freeze

    BODY = <<-XML
      <soapenv:Envelope
      xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:urn="urn:ec.europa.eu:taxud:vies:services:checkVat:types">
        <soapenv:Header/>
        <soapenv:Body>
           <urn:checkVat>
              <urn:countryCode>{COUNTRY_CODE}</urn:countryCode>
              <urn:vatNumber>{NUMBER}</urn:vatNumber>
           </urn:checkVat>
        </soapenv:Body>
      </soapenv:Envelope>
    XML

    def self.validate(number)
      return :failed if number.size < 4

      response = send_request(number[0..1], number[2..-1])
      return :failed unless response.is_a? Net::HTTPSuccess
      return :failed if response.body.include?('soap:Fault')
      return :timeout if response.body.include?('TIMEOUT')
      return :timeout if response.body.include?('MS_MAX_CONCURRENT_REQ')

      setup_response(response)
    rescue Net::OpenTimeout
      :timeout
    rescue Net::HTTPServerError
      :server_error
    end

    def self.setup_response(response)
      body = response_xml(response)
      {
        valid: extract_data(body, 3) == 'true',
        country_code: extract_data(body, 0),
        vat_number: extract_data(body, 1),
        request_date: convert_date(extract_data(body, 2)),
        name: extract_data(body, 4),
        address: extract_data(body, 5)
      }
    end

    def self.response_xml(response)
      xml = REXML::Document.new(response.body)
      xml.elements.first.elements[2].elements[1]
    end

    def self.convert_date(date)
      return unless date

      Date.parse(date)
    end

    def self.extract_data(body, position)
      body[position]&.text
    end

    def self.charge_vat?(origin_country, number)
      return false if number.nil? || number.empty?

      Europe::Vat::Fromat::VAT_REGEX.key?(origin_country.to_sym) ||
        Europe::Vat::Fromat::VAT_REGEX.key?(number[0..1].to_sym)
    end

    def self.send_request(country_code, number)
      uri = URI.parse(WSDL)

      body = BODY.dup.gsub('{COUNTRY_CODE}', country_code)
      body = body.gsub('{NUMBER}', number)

      # Create the HTTP objects
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri, HEADERS)
      request.body = body

      # Send the request
      http.request(request)
    end
  end
end
