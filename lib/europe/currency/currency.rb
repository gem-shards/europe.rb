# Source: Wikipedia
require 'europe/currency/exchange_rates'

# Europe Gem
module Europe
  # currency
  module Currency
    CURRENCIES = {
      EUR: { name: 'Euro', symbol: '€', html: '&euro;' },
      BGN: { name: 'Lev', symbol: 'лв', html: '&#1083;&#1074;' },
      CZK: { name: 'Koruna', symbol: 'Kč', html: '&#75;&#269;' },
      DKK: { name: 'Krone', symbol: 'kr.', html: '&#107;&#114;' },
      GBP: { name: 'Pound', symbol: '£', html: '&#163;' },
      HRK: { name: 'Kuna', symbol: 'kn.', html: '&#107;&#110;' },
      HUF: { name: 'Forint', symbol: 'Ft', html: '&#70;&#116;' },
      PLN: { name: 'Zloty', symbol: 'zł', html: '&#122;&#322;' },
      RON: { name: 'Leu', symbol: 'lei', html: '&#108;&#101;&#105;' },
      SEK: { name: 'Krona', symbol: 'kr', html: '&#107;&#114;' } }
  end
end
