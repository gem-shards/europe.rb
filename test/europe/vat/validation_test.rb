require 'test_helper'

module Europe
  module Vat
    # CurrencyTest
    class ValidationTest < Minitest::Test
      include Benchmark

      def test_validation_of_false_vat_number
        validate_false_vat = Europe::Vat.validate('NL', '123456789B01')
        assert_equal false, validate_false_vat[:valid]
      end

      def test_validation_of_correct_vat_number
        # PostNL
        validate_correct_vat = Europe::Vat.validate('NL', '009291477B01')
        assert validate_correct_vat[:valid]

        # Sky
        validate_correct_vat = Europe::Vat.validate('GB', '440627467')
        assert validate_correct_vat[:valid]

        # Volkswagen
        validate_correct_vat = Europe::Vat.validate('DE', '115235681')
        assert validate_correct_vat[:valid]
      end
    end
  end
end
