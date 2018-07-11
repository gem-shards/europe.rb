# Europe Gem
module Europe
  # VAT
  module Postal
    POSTAL_REGEX = {
      AT: /^\d{4}$/,
      BE: /^\d{4}$/,
      BG: /^\d{4}$/,
      CY: /^\d{4}$/,
      CZ: /^\d{3} \d{2}$/,
      DE: /^\d{4}$/,
      DK: /^\d{4}$/,
      EE: /^\d{5}$/,
      EL: /^\d{3} \d{2}$/,
      ES: /^\d{5}$/,
      FI: /^\d{5}$/,
      FR: /^\d{5}$/,
      GB: [/^GB(\d{3} \d{4} \d{2}( \d{3}5)?)$/, /^GB(HA|GD)\d{3}(6|7)$/],
      HR: /^\d{5}$/,
      HU: /^\d{4}$/,
      IE: /^IE\d[A-Z0-9\+\*|\d]\d{5}([A-Z]|WI)$/,
      IT: /^\d{5}$/,
      LT: /^LT\-\d{5}$/,
      LU: /^\d{4}$/,
      LV: /^LV\-\d{4}$/,
      MT: /^\w{3} \d{4}$/,
      NL: /^\d{4}\w{2}$/,
      PL: /^\d{2}-\d{3}$/,
      PT: /^\d{4}-\d{3}$/,
      RO: /^\d{6}$/,
      SE: /^\d{3} \d{2}$/,
      SI: /^SI\d{8}$/,
      SK: /^SK\d{10}$/
    }.freeze

    def self.validate(_country_code, _postal_code); end
  end
end
