# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'securerandom'

module Europe
  module Vat
    # Batch VAT validation via VIES REST API
    module Batch
      BATCH_API_URL = 'https://ec.europa.eu/taxation_customs/vies/rest-api/vat-validation'
      BATCH_REPORT_URL = 'https://ec.europa.eu/taxation_customs/vies/rest-api/vat-validation-report'

      BATCH_ERRORS = {
        'VOW-ERR-6000' => :invalid_file_extension,
        'VOW-ERR-6001' => :too_many_rows,
        'VOW-ERR-6002' => :too_few_rows,
        'VOW-ERR-6005' => :filter_violation,
        'VOW-ERR-6006' => :token_not_found,
        'VOW-ERR-6007' => :invalid_file_structure,
        'VOW-ERR-6008' => :invalid_file_structure,
        'VOW-ERR-6011' => :file_too_large
      }.freeze

      BATCH_MIN_ROWS = 3
      BATCH_MAX_ROWS = 100

      HEADERS = {
        'Content-Type' => 'application/json',
        'Accept' => 'application/json'
      }.freeze

      class << self
        def validate(vat_numbers, requester: nil)
          return :too_few_rows if vat_numbers.size < BATCH_MIN_ROWS
          return :too_many_rows if vat_numbers.size > BATCH_MAX_ROWS

          with_error_handling do
            body = parse_json_response(upload(generate_csv(vat_numbers, requester)))
            return body if body.is_a?(Symbol)

            { token: body['token'] }
          end
        end

        def status(token)
          with_error_handling do
            body = parse_json_response(http_get("#{BATCH_API_URL}/#{token}", HEADERS))
            return body if body.is_a?(Symbol)

            {
              token: body['token'], filename: body['filename'],
              status: body['status']&.downcase&.to_sym, percentage: body['percentage'],
              created_at: body['creationDateTime'], completed_at: body['completionTime']
            }
          end
        end

        def result(token)
          with_error_handling do
            response = http_get("#{BATCH_REPORT_URL}/#{token}")
            return handle_error(response) unless response.is_a?(Net::HTTPSuccess)

            error = check_json_error(response)
            return error if error

            { data: response.body, content_type: response['Content-Type'], filename: extract_filename(response) }
          end
        end

        private

        def with_error_handling
          yield
        rescue Net::OpenTimeout, Net::ReadTimeout
          :timeout
        rescue Errno::ECONNREFUSED, Errno::ECONNRESET, Errno::ETIMEDOUT, SocketError, OpenSSL::SSL::SSLError
          :service_unavailable
        rescue JSON::ParserError
          :service_error
        end

        def http_get(url, headers = {})
          uri = URI.parse(url)
          Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            http.request(Net::HTTP::Get.new(uri.request_uri, headers))
          end
        end

        def parse_json_response(response)
          return handle_error(response) unless response.is_a?(Net::HTTPSuccess)

          body = JSON.parse(response.body)
          return handle_error_body(body) if body['actionSucceed'] == false

          body
        end

        def check_json_error(response)
          return unless response['Content-Type']&.include?('application/json')

          body = JSON.parse(response.body)
          handle_error_body(body) if body['actionSucceed'] == false
        end

        def extract_filename(response)
          disposition = response['Content-Disposition']
          return unless disposition

          disposition.match(/filename="?(.+?)"?(?:;|$)/)&.captures&.first
        end

        def handle_error(response)
          body = JSON.parse(response.body)
          handle_error_body(body)
        rescue JSON::ParserError
          :service_error
        end

        def handle_error_body(body)
          error_code = body.dig('errorWrappers', 0, 'error')
          BATCH_ERRORS[error_code] || Vat::VIES_ERRORS[error_code] || :service_error
        end

        def generate_csv(vat_numbers, requester)
          requester_cc = requester ? requester[0..1] : ''
          requester_vat = requester ? requester[2..-1] : ''
          rows = ['"MS Code","VAT Number","Requester MS Code","Requester VAT Number"']
          vat_numbers.each do |vat|
            rows << "\"#{vat[0..1]}\",\"#{vat[2..-1]}\",\"#{requester_cc}\",\"#{requester_vat}\""
          end
          "#{rows.join("\n")}\n"
        end

        def upload(csv_content)
          uri = URI.parse(BATCH_API_URL)
          boundary = "EuropeGem#{SecureRandom.hex(16)}"
          Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
            request = Net::HTTP::Post.new(uri.request_uri)
            request['Content-Type'] = "multipart/form-data; boundary=#{boundary}"
            request['Accept'] = 'application/json'
            request.body = build_multipart_body(csv_content, boundary)
            http.request(request)
          end
        end

        def build_multipart_body(csv_content, boundary)
          "--#{boundary}\r\n" \
            "Content-Disposition: form-data; name=\"fileToUpload\"; filename=\"batch.csv\"\r\n" \
            "Content-Type: text/csv\r\n\r\n" \
            "#{csv_content}" \
            "\r\n--#{boundary}--\r\n"
        end
      end
    end
  end
end
