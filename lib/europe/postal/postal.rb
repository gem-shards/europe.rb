# frozen_string_literal: true

# Europe Gem
module Europe
  # VAT
  module Postal
    # rubocop:disable LineLength
    POSTAL_REGEX = {
      AT: /^\d{4}$/,
      BE: /^\d{4}$/,
      BG: /^\d{4}$/,
      CY: /^\d{4}$/,
      CZ: /^\d{3} \d{2}$/,
      DE: /^\d{5}$/,
      DK: /^\d{4}$/,
      EE: /^\d{5}$/,
      EL: /^\d{3} \d{2}$/,
      ES: /^\d{5}$/,
      FI: /^\d{5}$/,
      FR: /^\d{3} \d{2}$/,
      GB: /GIR[ ]?0AA|((AB|AL|B|BA|BB|BD|BH|BL|BN|BR|BS|BT|CA|CB|CF|CH|CM|CO|CR|CT|CV|CW|DA|DD|DE|DG|DH|DL|DN|DT|DY|E|EC|EH|EN|EX|FK|FY|G|GL|GY|GU|HA|HD|HG|HP|HR|HS|HU|HX|IG|IM|IP|IV|JE|KA|KT|KW|KY|L|LA|LD|LE|LL|LN|LS|LU|M|ME|MK|ML|N|NE|NG|NN|NP|NR|NW|OL|OX|PA|PE|PH|PL|PO|PR|RG|RH|RM|S|SA|SE|SG|SK|SL|SM|SN|SO|SP|SR|SS|ST|SW|SY|TA|TD|TF|TN|TQ|TR|TS|TW|UB|W|WA|WC|WD|WF|WN|WR|WS|WV|YO|ZE)(\d[\dA-Z]?[ ]?\d[ABD-HJLN-UW-Z]{2}))|BFPO[ ]?\d{1,4}/,
      HR: /^\d{5}$/,
      HU: /^\d{4}$/,
      IE: /^IE\d[A-Z0-9\+\*|\d]\d{5}([A-Z]|WI)$/,
      IT: /^\d{5}$/,
      LT: /^LT\-\d{5}$/,
      LU: /^\d{4}$/,
      LV: /^LV\-\d{4}$/,
      MT: /^\w{3} \d{2,4}$/,
      NL: /^\d{4}[ ]?[A-Z]{2}$/,
      PL: /^\d{2}-\d{3}$/,
      PT: /^\d{4}([\-]\d{3})?$/,
      RO: /^\d{6}$/,
      SE: /^\d{3}[ ]?\d{2}$/,
      SI: /^\d{4}$/,
      SK: /^\d{3}[ ]?\d{2}$/
    }.freeze
    # rubocop:enable LineLength

    def self.validate(country_code, postal_code)
      return false unless POSTAL_REGEX.key?(country_code.to_sym)

      match_postal_code(postal_code, country_code)
    end

    def self.match_postal_code(postal_code, country_code)
      if POSTAL_REGEX[country_code.to_sym].is_a?(Array)
        POSTAL_REGEX[country_code.to_sym].each do |regex|
          return true if regex.match(postal_code)
        end
      elsif POSTAL_REGEX[country_code.to_sym].match(postal_code)
        return true
      end
      false
    end
  end
end
