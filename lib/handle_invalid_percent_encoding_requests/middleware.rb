# Via https://gist.github.com/bf4/d26259acfa29f3b9882b#file-exception_app-rb

module HandleInvalidPercentEncodingRequests

  class Middleware
    def initialize(app, stdout=STDOUT)
      @app = app
      @logger = defined?(Rails.logger) ? Rails.logger : Logger.new(stdout)
    end

    def call(env)
      # calling env.dup here prevents bad things from happening
      request = Rack::Request.new(env.dup)

      # calling request.params is sufficient to trigger the error see
      # https://github.com/rack/rack/issues/337#issuecomment-46453404
      request.params
      @app.call(env)

    # Rescue from that specific ArgumentError
    rescue ArgumentError => e
      raise unless e.message =~ /invalid %-encoding/
      error_response
    end


    private

    def error_response
      @logger.info "Bad request. Returning 400 due to #{e.message}" + \
                  " from request with env #{request.inspect}"

      headers = { 'Content-Type' => "text/plain; charset=utf-8" }
      text = "Bad Request"
      [400, headers, [text]]
    end
  end

end
