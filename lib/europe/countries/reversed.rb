# frozen_string_literal: true

module Europe
  # Countries
  module Countries
    # Reversed
    module Reversed
      def self.generate(country_value)
        COUNTRIES.each_with_object({}) do |(key, value), out|
          reverse_handle_value(out, key, value, country_value)
        end
      end

      def self.reverse_handle_value(out, key, value, country_value)
        if out[value[country_value.to_sym]]
          reverse_handle_array(out, key, value, country_value)
        else
          out[value[country_value.to_sym]] = key
        end
      end

      def self.reverse_handle_array(out, key, value, country_value)
        if out[value[country_value.to_sym]].is_a?(Array)
          out[value[country_value.to_sym]] << key
        else
          out[value[country_value.to_sym]] =
            [out[value[country_value.to_sym]], key]
        end
      end
    end
  end
end
