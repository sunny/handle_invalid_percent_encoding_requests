module HandleInvalidPercentEncodingRequests


  # Via https://gist.github.com/bf4/d26259acfa29f3b9882b#file-exception_app-rb
  class Middleware
    DEFAULT_CONTENT_TYPE = 'text/html'
    DEFAULT_CHARSET      = 'utf-8'

    attr_reader :logger
    def initialize(app, stdout=STDOUT)
      @app = app
      @logger = defined?(Rails.logger) ? Rails.logger : Logger.new(stdout)
    end

    def call(env)
      begin
        # calling env.dup here prevents bad things from happening
        request = Rack::Request.new(env.dup)

        # calling request.params is sufficient to trigger the error
        # see https://github.com/rack/rack/issues/337#issuecomment-46453404
        request.params
        @app.call(env)

      rescue ArgumentError => e
        raise unless e.message =~ /invalid %-encoding/

        logger.info "Bad request. Returning 400 due to #{e.message}" + \
                    " from request with env #{request.inspect}"

        body = "Bad Request"
        return [400, {
                        'Content-Type' => "text/plain; charset=utf-8",
                        'Content-Length' => body.bytesize.to_s
                      }, [body]]
      end
    end
  end

end
