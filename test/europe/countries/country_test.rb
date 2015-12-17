require 'test_helper'

module Europe
  module Countries
    # CountryTest
    class CountryTest < Minitest::Test
      include Benchmark

      def test_country_by_name
        reversed_hash = Europe::Countries.name_to_code
        assert_equal reversed_hash['Netherlands'], :NL
        assert_equal reversed_hash['Ireland'], :IE
      end
    end
  end
end
