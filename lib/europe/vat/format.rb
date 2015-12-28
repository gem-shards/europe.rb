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
        CY: /^CY\d{8}[A-Z]$/,
        CZ: /^CZ(\d{8}|\d{9}|\d{10})$/,
        DE: /^DE\d{9}$/,
        DK: /^DK\d{2} \d{2} \d{2} \d{2}$/,
        EE: /^EE\d{9}$/,
        EL: /^EL\d{9}$/,
        ES: /^ES([A-Z0-9]\d{7}[A-Z0-9])$/,
        FI: /^FI\d{8}$/,
        FR: /^FR[A-Z0-9][A-Z0-9] \d{9}$/,
        GB: [/^GB(\d{3} \d{4} \d{2}( \d{3}5)?)$/, /^GB(HA|GD)\d{3}(6|7)$/],
        HR: /^HR\d{11}$/,
        HU: /^HU\d{8}$/,
        IE: /^IE\d[A-Z0-9\+\*|\d]\d{5}([A-Z]|WI)$/,
        IT: /^IT\d{11}$/,
        LT: /^LT(\d{9}|\d{12})$/,
        LU: /^LU\d{8}$/,
        LV: /^LV\d{11}$/,
        MT: /^MT\d{8}$/,
        NL: /^NL\d{9}B\d\d$/,
        PL: /^PL\d{10}$/,
        PT: /^PT\d{9}$/,
        RO: /^RO\d{2,10}$/,
        SE: /^SE\d{12}$/,
        SI: /^SI\d{8}$/,
        SK: /^SK\d{10}$/
      }

      def self.validate(number)
        country_code = number[0..1].to_sym
        number = sanitize_number(number, country_code)
        return false unless VAT_REGEX.keys.include?(country_code)
        match_vat_number(number, country_code)
      end

      def self.sanitize_number(number, country_code)
        if [:GB, :DK, :FR].include?(country_code)
          number.gsub(/\.|\t/, '').upcase
        else
          number.gsub(/\.|\t|\s/, '').upcase
        end
      end

      private

      def self.match_vat_number(number, country_code)
        if VAT_REGEX[country_code.to_sym].is_a?(Array)
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
