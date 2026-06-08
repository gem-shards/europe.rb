# frozen_string_literal: true

require 'test_helper'

module Europe
  module Vat
    SERVICE_UNAVAILABLE_BODY = '{"actionSucceed":false,"errorWrappers":' \
                               '[{"error":"SERVICE_UNAVAILABLE","message":' \
                               '"An error was encountered either at the national ' \
                               'level or at the European Commission"}]}'
    MS_UNAVAILABLE_BODY = '{"actionSucceed":false,"errorWrappers":' \
                          '[{"error":"MS_UNAVAILABLE","message":"The Member State service is unavailable"}]}'
    GLOBAL_RATE_LIMITED_BODY = '{"actionSucceed":false,"errorWrappers":' \
                               '[{"error":"GLOBAL_MAX_CONCURRENT_REQ","message":' \
                               '"Your Request for VAT validation has not been processed; ' \
                               'your max. number of concurrent requests has been reached"}]}'
    MS_RATE_LIMITED_BODY = '{"actionSucceed":false,"errorWrappers":' \
                           '[{"error":"MS_MAX_CONCURRENT_REQ","message":' \
                           '"Your Request for VAT validation has not been processed; ' \
                           'your max. number of concurrent requests for this Member State has been reached"}]}'
    INVALID_INPUT_BODY = '{"actionSucceed":false,"errorWrappers":' \
                         '[{"error":"INVALID_INPUT","message":"The provided CountryCode is invalid"}]}'
    VIES_TIMEOUT_BODY = '{"actionSucceed":false,"errorWrappers":' \
                        '[{"error":"TIMEOUT","message":"The Member State service could not be reached in time"}]}'

    # ValidationTest
    class ValidationTest < Minitest::Test
      include Benchmark

      def setup
        WebMock.disable!
      end

      def test_validation_of_short_vat_number
        assert_equal :invalid_input, Europe::Vat.validate('6')
      end

      def test_validation_of_false_vat_number
        validate_false_vat = Europe::Vat.validate('NL123456789B01')
        assert_equal false, validate_false_vat[:valid]
      end

      def test_validation_of_vat_number_with_spaces
        assert Europe::Vat.validate('DK 474 587 14')
      end

      def test_validation_of_correct_vat_number
        # PostNL
        validate_correct_vat = Europe::Vat.validate('NL009291477B01')
        assert validate_correct_vat[:valid] \
          unless validate_correct_vat.is_a?(Symbol)

        # Volkswagen
        validate_correct_vat = Europe::Vat.validate('DE115235681')
        assert validate_correct_vat[:valid] \
          unless validate_correct_vat.is_a?(Symbol)
      end

      def test_timeout
        WebMock.enable!
        stub_request(:post, Europe::Vat::API_URL).to_timeout
        assert_equal :timeout, Europe::Vat.validate('DE115235681')
        WebMock.disable!
      end

      def test_connection_refused
        WebMock.enable!
        stub_request(:post, Europe::Vat::API_URL).to_raise(Errno::ECONNREFUSED)
        assert_equal :service_unavailable, Europe::Vat.validate('DE115235681')
        WebMock.disable!
      end

      def test_server_error_without_body
        WebMock.enable!
        stub_request(:post, Europe::Vat::API_URL)
          .to_return(status: 500, body: '')
        assert_equal :service_error, Europe::Vat.validate('DE115235681')
        WebMock.disable!
      end

      def test_service_unavailable_error
        assert_vies_error 500, SERVICE_UNAVAILABLE_BODY,
                          'DE115235681', :service_unavailable
      end

      def test_ms_unavailable_error
        assert_vies_error 500, MS_UNAVAILABLE_BODY,
                          'DE115235681', :ms_unavailable
      end

      def test_rate_limited_global
        assert_vies_error 500, GLOBAL_RATE_LIMITED_BODY,
                          'DE115235681', :rate_limited
      end

      def test_rate_limited_member_state
        assert_vies_error 500, MS_RATE_LIMITED_BODY,
                          'DE115235681', :rate_limited
      end

      def test_invalid_input_error
        assert_vies_error 400, INVALID_INPUT_BODY,
                          'XX123456789', :invalid_input
      end

      def test_vies_timeout_error
        assert_vies_error 500, VIES_TIMEOUT_BODY,
                          'DE115235681', :timeout
      end

      private

      def assert_vies_error(status, body, vat, expected)
        WebMock.enable!
        stub_request(:post, Europe::Vat::API_URL)
          .to_return(
            status: status, body: body,
            headers: { 'Content-Type' => 'application/json' }
          )
        assert_equal expected, Europe::Vat.validate(vat)
        WebMock.disable!
      end
    end
  end
end
