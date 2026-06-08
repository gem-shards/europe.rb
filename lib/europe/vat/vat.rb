# frozen_string_literal: true

require 'europe/vat/rates'
require 'europe/vat/format'
require 'europe/vat/batch'
require 'uri'
require 'net/http'
require 'json'
require 'date'

# Europe Gem
module Europe
  # VAT
  module Vat
    API_URL = 'https://ec.europa.eu/taxation_customs/vies/rest-api/check-vat-number'
    HEADERS = {
      'Content-Type' => 'application/json',
      'Accept' => 'application/json'
    }.freeze

    VIES_ERRORS = {
      'INVALID_INPUT' => :invalid_input,
      'GLOBAL_MAX_CONCURRENT_REQ' => :rate_limited,
      'MS_MAX_CONCURRENT_REQ' => :rate_limited,
      'SERVICE_UNAVAILABLE' => :service_unavailable,
      'MS_UNAVAILABLE' => :ms_unavailable,
      'TIMEOUT' => :timeout
    }.freeze

    def self.validate(number)
      return :invalid_input if number.size < 4

      response = send_request(number[0..1], number[2..-1])
      return handle_error_response(response) unless response.is_a?(Net::HTTPSuccess)

      setup_response(response)
    rescue Net::OpenTimeout, Net::ReadTimeout
      :timeout
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, SocketError, OpenSSL::SSL::SSLError
      :service_unavailable
    end

    def self.validate_with_country_code(country_code, number)
      return :invalid_input if number.size < 4

      # Remove country code from number if it's present
      number = number[2..-1] if number[0..1].upcase.to_s == country_code.to_s

      response = send_request(country_code, number)
      return handle_error_response(response) unless response.is_a?(Net::HTTPSuccess)

      setup_response(response)
    rescue Net::OpenTimeout, Net::ReadTimeout
      :timeout
    rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, SocketError, OpenSSL::SSL::SSLError
      :service_unavailable
    end

    def self.batch_validate(vat_numbers, requester: nil)
      Batch.validate(vat_numbers, requester: requester)
    end

    def self.batch_status(token)
      Batch.status(token)
    end

    def self.batch_result(token)
      Batch.result(token)
    end

    def self.handle_error_response(response)
      body = JSON.parse(response.body)
      error_code = body.dig('errorWrappers', 0, 'error')
      VIES_ERRORS[error_code] || :service_error
    rescue JSON::ParserError
      :service_error
    end

    def self.setup_response(response)
      body = JSON.parse(response.body)
      {
        valid: body['valid'] == true,
        country_code: body['countryCode'],
        vat_number: body['vatNumber'],
        request_date: convert_date(body['requestDate']),
        name: body['name'],
        address: body['address']
      }
    end

    def self.convert_date(date)
      return unless date

      Date.parse(date)
    end

    def self.charge_vat?(origin_country, number)
      return false if number.nil? || number.empty?

      Europe::Vat::Fromat::VAT_REGEX.key?(origin_country.to_sym) ||
        Europe::Vat::Fromat::VAT_REGEX.key?(number[0..1].to_sym)
    end

    def self.send_request(country_code, number)
      uri = URI.parse(API_URL)

      Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
        request = Net::HTTP::Post.new(uri.request_uri, HEADERS)
        request.body = JSON.generate(
          countryCode: country_code,
          vatNumber: number
        )
        http.request(request)
      end
    end
  end
end
