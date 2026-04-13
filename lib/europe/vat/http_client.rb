# frozen_string_literal: true

require 'net/http'
require 'openssl'

module Europe
  module Vat
    # Shared HTTP/SSL client builder used by Vat and Rates modules.
    module HttpClient
      def build_http_client(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
        store = OpenSSL::X509::Store.new
        store.set_default_paths
        http.cert_store = store
        http
      end
    end
  end
end
