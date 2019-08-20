# frozen_string_literal: true

require 'test_helper'

module Europe
  module Vat
    # FormatTest
    class FormatTest < Minitest::Test
      include Benchmark

      VAT_FORMAT_VALIDATION = {
        AT: 'ATU99999999',
        BE: 'BE0999999999',
        BG: %w[BG999999999 BG9999999999],
        CY: 'CY99999999L',
        CZ: %w[CZ99999999 CZ999999999 CZ9999999999],
        DE: 'DE999999999',
        DK: 'DK99 99 99 99',
        EE: 'EE999999999',
        EL: 'EL999999999',
        ES: 'ESX9999999X',
        FI: 'FI99999999',
        FR: 'FRXX 999999999',
        GB: ['GB999 9999 99 9995',
             'GBGD9996',
             'GBHA9997',
             'GB999 9999 99'],
        HR: 'HR99999999999',
        HU: 'HU99999999',
        IE: %w[IE9S99999L IE9999999WI],
        IT: 'IT99999999999',
        LT: %w[LT999999999 LT999999999999],
        LU: 'LU99999999',
        LV: 'LV99999999999',
        MT: 'MT99999999',
        NL: %w[NL999999999B99 NL999.9999.99.B99],
        PL: 'PL9999999999',
        PT: 'PT999999999',
        RO: 'RO999999999',
        SE: 'SE999999999999',
        SI: 'SI99999999',
        SK: 'SK9999999999'
      }.freeze

      def test_all_vat_numbers_on_format
        VAT_FORMAT_VALIDATION.each_value do |number|
          if number.is_a?(Array)
            number.each do |num|
              check_vat_number(num)
            end
          else
            check_vat_number(number)
          end
        end
      end

      def check_vat_number(number)
        check_true_values(number)
        check_character_and_digit(number) \
          if number[2..-1].include?('X')
        check_integer(number) if number[2..-1].include?('9')
        check_alphanumeric(number) if number[2..-1].include?('L')
        check_false_values(number)
      end

      def check_character_and_digit(number)
        assert_equal true, Europe::Vat::Format.validate(
          number[0..1] +
          number[2..-1].gsub(/X/, [*('A'..'Z'), *('0'..'9')].sample)
        )
      end

      def check_integer(number)
        {
          number[0..1] + number[2..-1].gsub(/9/, [*('0'..'9')].sample) => true,
          number.gsub(/9/, rand(10).to_s) => true,
          number.gsub(/9/, [*('A'..'Z')].sample(1).join) => false
        }.each do |key, value|
          assert_equal value, Europe::Vat::Format.validate(key)
        end
      end

      def check_alphanumeric(number)
        assert_equal true, Europe::Vat::Format.validate(
          number[0..1] + number[2..-1].gsub(/L/, [*('A'..'Z')].sample)
        )
        assert_equal false, Europe::Vat::Format.validate(
          number[0..1] + number[2..-1].gsub(/L/, [*('0'..'9')].sample)
        )
      end

      def check_true_values(number)
        assert_equal true, Europe::Vat::Format.validate(number)
      end

      def check_false_values(number)
        assert_equal false, Europe::Vat::Format.validate(
          number + [*('A'..'Z'), *('0'..'9')].sample(3).join
        )
        assert_equal false, Europe::Vat::Format.validate(
          [*('A'..'Z'), *('0'..'9')].sample + number
        )
      end
    end
  end
end
