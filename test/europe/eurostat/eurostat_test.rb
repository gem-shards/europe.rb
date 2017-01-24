#!/bin/env ruby
# encoding: utf-8
require 'test_helper'

module Europe
  module Eurostat
    # CurrencyTest
    class EurostatTest < Minitest::Test
      include Benchmark

      def test_eurostat_retrieval
        p Europe::Eurostat.retrieve('nama_gdp_c','')
      end
    end
  end
end
