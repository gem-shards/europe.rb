# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path('lib', __dir__))
require 'europe'
require 'net/http'

puts 'Testing Europe::Vat::Rates.retrieve...'
begin
  rates = Europe::Vat::Rates.retrieve
  puts "Rates retrieved: #{rates.keys.first} => #{rates.values.first}"
rescue StandardError => e
  puts "Rates retrieval failed: #{e.class} - #{e.message}"
end

puts "\nTesting Europe::Vat.validate (Network)..."
begin
  # Use a dummy number that might fail validation but should trigger a network request
  # NL009291477B01 is a valid number from README
  result = Europe::Vat.validate('NL009291477B01')
  puts "Validation result: #{result}"
rescue StandardError => e
  puts "Validation failed: #{e.class} - #{e.message}"
end
