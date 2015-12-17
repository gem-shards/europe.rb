require 'test_helper'

module Europe
  module Currency
    # ExchangeRatesTest
    class ExchangeRatesTest < Minitest::Test
      include Benchmark

      def test_retrieval_exchange_rates
        rates = Europe::Currency::ExchangeRates.retrieve
        assert rates[:rates].keys.include?(:GBP)
      end
    end
  end
end
