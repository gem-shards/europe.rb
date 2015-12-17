require 'test_helper'

module Europe
  module Vat
    # FormatTest
    class FormatTest < Minitest::Test
      include Benchmark

      VAT_FORMAT_VALIDATION = {
        AT: 'ATU99999999',
        BE: 'BE0999999999'
      }

      def test_all_vat_numbers_on_format
        VAT_FORMAT_VALIDATION.each do |country, number|
          if number.is_a?(Array)
            number.each do |num|
              check_vat_number(country, num)
            end
          else
            check_vat_number(country, number)
          end
        end
      end

      def check_vat_number(country, number)
        assert_equal true, Europe::Vat::Format.validate(country, number)
        assert_equal true, Europe::Vat::Format.validate(country, number.gsub!(/9/, rand(10).to_s))
        # assert_equal true, Europe::Vat::Format.validate(country, number.gsub!(/(?:\w\w)\X/, [*('A'..'Z'),*('0'..'9')].sample))
        # assert_equal true, Europe::Vat::Format.validate(country, number.gsub!(/(?:\w\w)\L/, [*('A'..'Z')].sample))

        assert_equal false, Europe::Vat::Format.validate(country, number.gsub!(/9/, [*('A'..'Z')].sample(1).join))
        assert_equal false, Europe::Vat::Format.validate(country, number + [*('A'..'Z'),*('0'..'9')].sample)
        assert_equal false, Europe::Vat::Format.validate(country, [*('A'..'Z'),*('0'..'9')].sample + number)
      end
    end
  end
end
