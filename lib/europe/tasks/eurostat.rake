# frozen_string_literal: true

require 'open-uri'

namespace :eurostat do
  desc 'Download categories from Eurostat Bulk Facility'
  task :download_categories do
    eurostat_bulk_url = 'http://ec.europa.eu/eurostat/' \
                        'estat-navtree-portlet-prod/BulkDownloadListing' \
                        '?sort=1&file='

    data = Net::HTTP.get_response(
      URI.parse("#{eurostat_bulk_url}table_of_contents_en.txt")
    ).body
    File.open('cat.txt', 'w') do |f|
      IO.copy_stream(data, f)
    end
  end
end
