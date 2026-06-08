# frozen_string_literal: true

require 'test_helper'

module Europe
  module Vat
    BATCH_SUCCESS_BODY = '{"token":"test-token-uuid"}'
    BATCH_STRUCTURE_ERROR_BODY = '{"actionSucceed":false,"errorWrappers":' \
                                 '[{"error":"VOW-ERR-6008","message":' \
                                 '"Your file does not match the expected structure"}]}'
    BATCH_TOKEN_NOT_FOUND_BODY = '{"actionSucceed":false,"errorWrappers":' \
                                 '[{"error":"VOW-ERR-6006","message":' \
                                 '"The token is not valid"}]}'
    BATCH_STATUS_PROCESSING_BODY = '{"token":"test-token-uuid","filename":"batch.csv",' \
                                   '"creationDateTime":"2026-06-08T09:47:13.720Z",' \
                                   '"status":"PROCESSING","processingStartTime":' \
                                   '"2026-06-08T09:47:13.852Z","percentage":66.67}'
    BATCH_STATUS_COMPLETED_BODY = '{"token":"test-token-uuid","filename":"batch.csv",' \
                                  '"creationDateTime":"2026-06-08T09:47:13.720Z",' \
                                  '"status":"COMPLETED","processingStartTime":' \
                                  '"2026-06-08T09:47:13.852Z","completionTime":' \
                                  '"2026-06-08T09:47:49.937Z","percentage":100.0}'

    class BatchValidationTest < Minitest::Test
      VAT_NUMBERS = %w[NL009291477B01 DE115235681 FR40303265045].freeze

      def setup
        WebMock.enable!
      end

      def teardown
        WebMock.disable!
      end

      def test_batch_validate_returns_token
        stub_request(:post, Europe::Vat::Batch::BATCH_API_URL)
          .to_return(status: 200, body: BATCH_SUCCESS_BODY,
                     headers: { 'Content-Type' => 'application/json' })

        result = Europe::Vat::Batch.validate(VAT_NUMBERS)
        assert_equal({ token: 'test-token-uuid' }, result)
      end

      def test_batch_validate_too_few_rows
        assert_equal :too_few_rows, Europe::Vat::Batch.validate(%w[NL009291477B01 DE115235681])
      end

      def test_batch_validate_too_many_rows
        numbers = (1..101).map { |i| "NL#{i.to_s.rjust(12, '0')}" }
        assert_equal :too_many_rows, Europe::Vat::Batch.validate(numbers)
      end

      def test_batch_validate_with_requester
        stub_request(:post, Europe::Vat::Batch::BATCH_API_URL)
          .with { |req| req.body.include?('NL') && req.body.include?('009291477B01') }
          .to_return(status: 200, body: BATCH_SUCCESS_BODY,
                     headers: { 'Content-Type' => 'application/json' })

        result = Europe::Vat::Batch.validate(VAT_NUMBERS, requester: 'NL009291477B01')
        assert_equal({ token: 'test-token-uuid' }, result)
      end

      def test_batch_validate_structure_error
        stub_request(:post, Europe::Vat::Batch::BATCH_API_URL)
          .to_return(status: 400, body: BATCH_STRUCTURE_ERROR_BODY,
                     headers: { 'Content-Type' => 'application/json' })

        assert_equal :invalid_file_structure, Europe::Vat::Batch.validate(VAT_NUMBERS)
      end

      def test_batch_validate_timeout
        stub_request(:post, Europe::Vat::Batch::BATCH_API_URL).to_timeout

        assert_equal :timeout, Europe::Vat::Batch.validate(VAT_NUMBERS)
      end

      def test_batch_validate_connection_refused
        stub_request(:post, Europe::Vat::Batch::BATCH_API_URL).to_raise(Errno::ECONNREFUSED)

        assert_equal :service_unavailable, Europe::Vat::Batch.validate(VAT_NUMBERS)
      end

      def test_batch_status_processing
        stub_request(:get, "#{Europe::Vat::Batch::BATCH_API_URL}/test-token-uuid")
          .to_return(status: 200, body: BATCH_STATUS_PROCESSING_BODY,
                     headers: { 'Content-Type' => 'application/json' })

        result = Europe::Vat::Batch.status('test-token-uuid')
        assert_equal :processing, result[:status]
        assert_equal 66.67, result[:percentage]
      end

      def test_batch_status_completed
        stub_request(:get, "#{Europe::Vat::Batch::BATCH_API_URL}/test-token-uuid")
          .to_return(status: 200, body: BATCH_STATUS_COMPLETED_BODY,
                     headers: { 'Content-Type' => 'application/json' })

        result = Europe::Vat::Batch.status('test-token-uuid')
        assert_equal :completed, result[:status]
        assert_equal 100.0, result[:percentage]
        assert_equal 'test-token-uuid', result[:token]
        refute_nil result[:completed_at]
      end

      def test_batch_status_invalid_token
        stub_request(:get, "#{Europe::Vat::Batch::BATCH_API_URL}/bad-token")
          .to_return(status: 400, body: BATCH_TOKEN_NOT_FOUND_BODY,
                     headers: { 'Content-Type' => 'application/json' })

        assert_equal :token_not_found, Europe::Vat::Batch.status('bad-token')
      end

      def test_batch_status_timeout
        stub_request(:get, "#{Europe::Vat::Batch::BATCH_API_URL}/test-token-uuid").to_timeout

        assert_equal :timeout, Europe::Vat::Batch.status('test-token-uuid')
      end

      def test_batch_result_returns_data
        stub_request(:get, "#{Europe::Vat::Batch::BATCH_REPORT_URL}/test-token-uuid")
          .to_return(
            status: 200,
            body: 'fake-xlsx-binary-data',
            headers: {
              'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              'Content-Disposition' => 'attachment; filename="report.xlsx"'
            }
          )

        result = Europe::Vat::Batch.result('test-token-uuid')
        assert_equal 'fake-xlsx-binary-data', result[:data]
        assert_equal 'report.xlsx', result[:filename]
        assert result[:content_type].include?('spreadsheetml')
      end

      def test_batch_result_invalid_token
        stub_request(:get, "#{Europe::Vat::Batch::BATCH_REPORT_URL}/bad-token")
          .to_return(status: 400, body: BATCH_TOKEN_NOT_FOUND_BODY,
                     headers: { 'Content-Type' => 'application/json' })

        assert_equal :token_not_found, Europe::Vat::Batch.result('bad-token')
      end

      def test_batch_result_timeout
        stub_request(:get, "#{Europe::Vat::Batch::BATCH_REPORT_URL}/test-token-uuid").to_timeout

        assert_equal :timeout, Europe::Vat::Batch.result('test-token-uuid')
      end

      def test_generate_batch_csv_format
        csv = Europe::Vat::Batch.send(:generate_csv, VAT_NUMBERS, nil)
        lines = csv.strip.split("\n")

        assert_equal 4, lines.size
        assert_equal '"MS Code","VAT Number","Requester MS Code","Requester VAT Number"', lines[0]
        assert_equal '"NL","009291477B01","",""', lines[1]
        assert_equal '"DE","115235681","",""', lines[2]
        assert_equal '"FR","40303265045","",""', lines[3]
      end

      def test_generate_batch_csv_with_requester
        csv = Europe::Vat::Batch.send(:generate_csv, VAT_NUMBERS, 'NL009291477B01')
        lines = csv.strip.split("\n")

        assert_equal '"NL","009291477B01","NL","009291477B01"', lines[1]
      end

      # Delegation tests — ensure Europe::Vat.batch_* still works
      def test_delegation_batch_validate
        stub_request(:post, Europe::Vat::Batch::BATCH_API_URL)
          .to_return(status: 200, body: BATCH_SUCCESS_BODY,
                     headers: { 'Content-Type' => 'application/json' })

        result = Europe::Vat.batch_validate(VAT_NUMBERS)
        assert_equal({ token: 'test-token-uuid' }, result)
      end

      def test_delegation_batch_status
        stub_request(:get, "#{Europe::Vat::Batch::BATCH_API_URL}/test-token-uuid")
          .to_return(status: 200, body: BATCH_STATUS_COMPLETED_BODY,
                     headers: { 'Content-Type' => 'application/json' })

        result = Europe::Vat.batch_status('test-token-uuid')
        assert_equal :completed, result[:status]
      end

      def test_delegation_batch_result
        stub_request(:get, "#{Europe::Vat::Batch::BATCH_REPORT_URL}/test-token-uuid")
          .to_return(
            status: 200,
            body: 'fake-xlsx-binary-data',
            headers: {
              'Content-Type' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
              'Content-Disposition' => 'attachment; filename="report.xlsx"'
            }
          )

        result = Europe::Vat.batch_result('test-token-uuid')
        assert_equal 'fake-xlsx-binary-data', result[:data]
      end
    end
  end
end
