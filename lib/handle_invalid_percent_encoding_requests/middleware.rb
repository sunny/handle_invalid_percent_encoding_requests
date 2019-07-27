# Via https://gist.github.com/bf4/d26259acfa29f3b9882b#file-exception_app-rb
module HandleInvalidPercentEncodingRequests
  module InvalidPercentEncodingErrorMatcher
    def self.===(error)
      error.is_a?(ArgumentError) &&
        error.message =~ /invalid %-encoding/
    end
  end

  module InvalidByteSequenceErrorMatcher
    def self.===(error)
      error.is_a?(ArgumentError) &&
        error.message == "invalid byte sequence in UTF-8"
    end
  end

  module NullByteErrorMatcher
    def self.===(error)
      error.is_a?(ArgumentError) &&
        error.message == "string contains null byte"
    end
  end

  # Rack Middleware inserted before the request that detects an encoding error
  # and returns an appropriate response.
  class Middleware
    def initialize(app, stdout = STDOUT)
      @app = app
      @logger = defined?(Rails.logger) ? Rails.logger : Logger.new(stdout)
    end

    # Called by Rack when a request comes through
    def call(env)
      # calling env.dup here prevents bad things from happening
      request = Rack::Request.new(env.dup)

      # calling request.params is sufficient to trigger the error see
      # https://github.com/rack/rack/issues/337#issuecomment-46453404
      request.params

      @app.call(env)

    rescue InvalidPercentEncodingErrorMatcher,
           InvalidByteSequenceErrorMatcher,
           NullByteErrorMatcher

      @logger.info "Bad request. Returning 400 due to #{e.class.name} " \
                   "#{e.message.inspect} from request with env " \
                   "#{request.inspect}"
      error_response
    end


    private

    def error_response
      headers = { "Content-Type" => "text/plain; charset=utf-8" }
      text = "Bad Request"
      [400, headers, [text]]
    end
  end
end
