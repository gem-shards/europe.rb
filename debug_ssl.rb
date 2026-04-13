# frozen_string_literal: true

require 'net/http'
require 'openssl'

uri = URI.parse('https://ec.europa.eu/taxation_customs/vies/services/checkVatService')

puts 'Attempt 1: Default'
begin
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.start do
    puts 'Connected!'
  end
rescue StandardError => e
  puts "Failed: #{e.message}"
end

puts "\nAttempt 2: VERIFY_NONE"
begin
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  http.start do
    puts 'Connected!'
  end
rescue StandardError => e
  puts "Failed: #{e.message}"
end

puts "\nAttempt 3: VERIFY_PEER with empty cert store + Request"
begin
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  store = OpenSSL::X509::Store.new
  store.set_default_paths
  http.cert_store = store

  request = Net::HTTP::Post.new(uri.request_uri)
  # VIES requires a body usually, but let's just see if we get a response or SSL error
  request.body = '<soapenv:Envelope ...>'

  response = http.request(request)
  puts "Response: #{response.code}"
rescue StandardError => e
  puts "Failed: #{e.message}"
end
