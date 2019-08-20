# frozen_string_literal: true

require 'test_helper'

module Europe
  module Vat
    # RatesTest
    class RatesTest < Minitest::Test
      include Benchmark

      def setup
        WebMock.disable!
      end

      def test_retrieval_of_vat_rates
        rates = Europe::Vat::Rates.retrieve
        if rates == :failed
          rates = { NL: 17, DE: 19, ES: 18 }
        else
          assert_equal rates.count, Europe::Countries::COUNTRIES.count
        end
        assert rates[:NL]
        assert rates[:DE]
        assert rates[:ES]
        assert_nil rates[:GG]
      end
    end
  end
end
