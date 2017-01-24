require 'net/http'
require 'uri'
require 'json'

# Europe Gem
module Europe
  # Eurostat
  module Eurostat
    # http://ec.europa.eu/eurostat/data/database
    STAT_URL = 'http://ec.europa.eu/eurostat/wdds' \
               '/rest/data/v2.1/json/en/'.freeze

    def self.retrieve(dataset, filters)
      fetch_stats(dataset, filters)
    end

    def self.generate_url(dataset, _filters)
      uri = URI.parse(STAT_URL + dataset)
      params = {
        precision: 1, geo: 'EU28',
        unit: 'EUR_HAB', time: '2010',
        indic_na: 'B1GM', unitLabel: 'code'
      }
      uri.query = URI.encode_www_form(params)
      p URI.encode_www_form(params)
      p uri.to_s
      uri
    end

    def self.fetch_stats(dataset, filters)
      uri = generate_url(dataset, filters)
      resp = Net::HTTP.get(uri)
      JSON.parse(resp)
    end
  end
end
