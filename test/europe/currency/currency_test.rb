#!/bin/env ruby
# encoding: utf-8

require 'test_helper'

module Europe
  module Currency
    # CurrencyTest
    class CurrencyTest < Minitest::Test
      include Benchmark

      def test_currency_retrieval
        assert_equal Europe::Currency::CURRENCIES[:EUR][:name], 'Euro'
        assert_equal Europe::Currency::CURRENCIES[:GBP][:symbol], '£'
        assert_equal Europe::Currency::CURRENCIES[:SEK][:html], '&#107;&#114;'
      end
    end
  end
end
