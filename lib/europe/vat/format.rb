# Europe Gem
module Europe
  # VAT
  module Vat
    # Format
    module Format
      VAT_REGEX = {
        AT: /^ATU\d{8}$/,
        BE: /^BE0\d{9}$/,
        BG: /^BG(\d{10}|\d{9})$/,
        CY: /^CY\d{8}L$/,
        CZ: /^CZ(\d{9}|\d{10}|\d{11})$/,
        DE: /^DE\d{9}$/,
        DK: /^DK\d{2} \d{2} \d{2} \d{2}$/,
        EE: /^EE\d{9}$/,
        EL: /^EL\d{9}$/,
        ES: /^ES(X\d{8}|\d{8}X)$/,
        FI: /^FI\d{8}$/
      }

      def self.validate(country_code, number)
        if VAT_REGEX[country_code.to_sym].is_a?
          VAT_REGEX[country_code.to_sym].each do |regex|
            return true if regex.match(number)
          end
        else
          return true if VAT_REGEX[country_code.to_sym].match(number)
        end
        false
      end
    end
  end
end
