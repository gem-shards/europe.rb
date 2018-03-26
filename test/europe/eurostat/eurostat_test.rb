#!/bin/env ruby
require 'test_helper'

module Europe
  module Eurostat
    # CurrencyTest
    class EurostatTest < Minitest::Test
      include Benchmark

      def test_eurostat_retrieval
        skip
        Europe::Eurostat.retrieve('nama_gdp_c', '')
      end
    end
  end
end
