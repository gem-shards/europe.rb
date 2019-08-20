# frozen_string_literal: true

require 'test_helper'

module Europe
  module Countries
    # CountryTest
    class CountryTest < Minitest::Test
      include Benchmark

      def test_country_by_name
        reversed_hash =
          Europe::Countries::Reversed.generate(:name)
        assert_equal reversed_hash['Netherlands'], :NL
        assert_equal reversed_hash['Ireland'], :IE

        reversed_hash =
          Europe::Countries::Reversed.generate(:currency)
        assert_equal reversed_hash[:EUR].count, 17
      end

      def test_eurozone
        assert Europe::Countries.eurozone.include?(:DE)
        assert_equal false, Europe::Countries.eurozone.include?(:UK)
      end
    end
  end
end
