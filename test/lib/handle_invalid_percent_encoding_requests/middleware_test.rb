require 'test_helper'
require 'rack/mock'
require 'handle_invalid_percent_encoding_requests/middleware'

module HandleInvalidPercentEncodingRequests
  class MiddlewareTest < Minitest::Test
    def setup
      # Silence stdout logging for this test
      @original_stdout = $stdout.clone
      $stdout.reopen File.new('/dev/null', 'w')

      app = lambda { |env| [200, {'Content-Type' => 'text/plain'}, ['All responses are OK']] }
      @middleware = Middleware.new(app)
    end

    def teardown
      $stdout.reopen @original_stdout
    end

    def test_valid_request
      assert_equal 200, @middleware.call(Rack::MockRequest.env_for)[0]
    end

    def test_invalid_percent_encoding
      env = Rack::MockRequest.env_for
      env['QUERY_STRING'] = 'invalid=%encoding%'
      assert_equal 400, @middleware.call(env)[0]
    end

    def test_invalid_byte_sequence
      env = Rack::MockRequest.env_for
      env['QUERY_STRING'] = "invalid=utf8\xc2"
      assert_equal 400, @middleware.call(env)[0]
    end
  end
end