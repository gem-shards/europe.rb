require 'open-uri'

namespace :eurostat do
  EUROSTAT_BULK_URL = 'http://ec.europa.eu/eurostat/' \
                      'estat-navtree-portlet-prod/BulkDownloadListing' \
                      '?sort=1&file='.freeze

  desc 'Download categories from Eurostat Bulk Facility'
  task :download_categories do
    data = Net::HTTP.get_response(
      URI.parse(EUROSTAT_BULK_URL + 'table_of_contents_en.txt')
    ).body
    File.open('cat.txt', 'w') do |f|
      IO.copy_stream(data, f)
    end
  end
end
