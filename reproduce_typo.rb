# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
require 'europe'

begin
  puts 'Testing Europe::Vat.charge_vat?...'
  # This should trigger the typo if the code path is executed
  result = Europe::Vat.charge_vat?('NL', 'NL800')
  puts "Result: #{result}"
rescue NameError => e
  puts "Caught expected error: #{e.message}"
end
