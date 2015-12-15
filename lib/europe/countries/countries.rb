#!/bin/env ruby
# encoding: utf-8

# Source: http://publications.europa.eu/code/pdf/370000en.htm

# Europe Gem
module Europe
  # Countries
  module Countries
    COUNTRIES = {
      BE: { name: 'Belgium',
            source_name: 'Belgique/België',
            official_name: 'Kingdom of Belgium' },
      BG: { name: 'Bulgaria',
            source_name: 'България',
            official_name: 'Republic of Bulgaria' },
      CZ: { name: 'Czech Republic',
            source_name: 'Česká republika',
            official_name: 'Czech Republic' },
      DK: { name: 'Denmark',
            source_name: 'Danmark',
            official_name: 'Kingdom of Denmark' },
      DE: { name: 'Germany',
            source_name: 'Deutschland',
            official_name: 'Federal Republic of Germany' },
      EE: { name: 'Estonia',
            source_name: 'Eesti',
            official_name: 'Republic of Estonia' },
      IE: { name: 'Ireland',
            source_name: 'Éire',
            official_name: 'Ireland' },
      EL: { name: 'Greece',
            source_name: 'Ελλάδα',
            official_name: 'Hellenic Republic' },
      ES: { name: 'Spain',
            source_name: 'España',
            official_name: 'Kingdom of Spain' },
      FR: { name: 'France',
            source_name: 'France',
            official_name: 'French Republic' },
      HR: { name: 'Croatia',
            source_name: 'Hrvatska',
            official_name: 'Republic of Croatia' },
      IT: { name: 'Italy',
            source_name: 'Italia',
            official_name: 'Italian Republic' },
      CY: { name: 'Cyprus',
            source_name: 'Κύπρος',
            official_name: 'Republic of Cyprus' },
      LV: { name: 'Latvia',
            source_name: 'Latvija',
            official_name: 'Republic of Latvia' },
      LT: { name: 'Lithuania',
            source_name: 'Lietuva',
            official_name: 'Republic of Lithuania' },
      LU: { name: 'Luxembourg',
            source_name: 'Luxembourg',
            official_name: 'Grand Duchy of Luxembourg' },
      HU: { name: 'Hungary',
            source_name: 'Magyarország',
            official_name: 'Hungary' },
      MT: { name: 'Malta',
            source_name: 'Malta',
            official_name: 'Republic of Malta' },
      NL: { name: 'Netherlands',
            source_name: 'Nederland',
            official_name: 'Kingdom of the Netherlands' },
      AT: { name: 'Austria',
            source_name: 'Österreich',
            official_name: 'Republic of Austria' },
      PL: { name: 'Poland',
            source_name: 'Polska',
            official_name: 'Republic of Poland' },
      PT: { name: 'Portugal',
            source_name: 'Portugal',
            official_name: 'Portuguese Republic' },
      RO: { name: 'Romania',
            source_name: 'România',
            official_name: 'Romania' },
      SI: { name: 'Slovenia',
            source_name: 'Slovenija',
            official_name: 'Republic of Slovenia' },
      SK: { name: 'Slovak Republic',
            source_name: 'Slovensko',
            official_name: 'Slovak Republic' },
      FI: { name: 'Finland',
            source_name: 'Suomi',
            official_name: 'Republic of Finland' },
      SE: { name: 'Sweden',
            source_name: 'Sverige',
            official_name: 'Kingdom of Sweden' },
      UK: { name: 'United Kingdom',
            source_name: 'United Kingdom',
            official_name: 'United Kingdom of Great ' \
                           'Britain and Northern Ireland' } }

    def self.name_to_code
      @name_to_code ||= COUNTRIES.each_with_object({}) do |(key, value), out|
        out[value[:name]] = key
      end
    end
  end
end
