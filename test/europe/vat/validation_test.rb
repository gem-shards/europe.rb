require 'test_helper'

module Europe
  module Vat
    # ValidationTest
    class ValidationTest < Minitest::Test
      include Benchmark

      def setup
        WebMock.disable!
      end

      def test_validation_of_false_vat_number
        validate_false_vat = Europe::Vat.validate('NL123456789B01')
        assert_equal false, validate_false_vat[:valid]
      end

      def test_validation_of_correct_vat_number
        # PostNL
        validate_correct_vat = Europe::Vat.validate('NL009291477B01')
        assert validate_correct_vat[:valid] \
          unless %i[timeout failed].include?(validate_correct_vat)

        # Sky
        validate_correct_vat = Europe::Vat.validate('GB440627467')
        assert validate_correct_vat[:valid] \
          unless %i[timeout failed].include?(validate_correct_vat)

        # Volkswagen
        validate_correct_vat = Europe::Vat.validate('DE115235681')
        assert validate_correct_vat[:valid] \
          unless %i[timeout failed].include?(validate_correct_vat)
      end

      def test_failed_request_to_soap_service
        WebMock.enable!
        stub_request(:any, 'http://ec.europa.eu/taxation_customs/vies/services/checkVatService').to_timeout
        Europe::Vat.validate('DE115235681')

        stub_request(:get, 'http://ec.europa.eu/taxation_customs/vies/services/checkVatService')
          .with(headers: { 'Accept' => '*/*', 'User-Agent' => 'Ruby' })
          .to_return(status: 421, body: '')
        Europe::Vat.validate('DE115235681')
        WebMock.disable!
      end
    end
  end
end
