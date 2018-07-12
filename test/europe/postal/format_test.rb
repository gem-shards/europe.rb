require 'test_helper'

module Europe
  module Postal
    # FormatTest
    class FormatTest < Minitest::Test
      def test_several_postal_codes
        # Netherlands
        assert Europe::Postal.validate('NL', '1000 AP')

        # German
        assert Europe::Postal.validate('DE', '02782')

        # UK
        assert Europe::Postal.validate('GB', 'SW1W 0NY')
      end

      def test_fail_several_postal_codes
        # Netherlands
        refute Europe::Postal.validate('NL', '1000x AP')

        # German
        refute Europe::Postal.validate('DE', 'BW02782')

        # UK
        refute Europe::Postal.validate('GB', 'XSW1Wxx 0NY')
      end
    end
  end
end
