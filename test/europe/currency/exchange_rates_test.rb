require 'test_helper'

module Europe
  module Currency
    # CurrencyTest
    class ExchangeRatesTest < Minitest::Test
      include Benchmark

      def test_retrieval_exchange_rates
        rates = Europe::Currency::ExchangeRates.retrieve
        assert_equal rates[:date].to_s,
                     DateTime.now.strftime('%Y-%m-%d')
        assert rates[:rates].keys.include?(:GBP)
      end
    end
  end
end
