require "rack/utf8_sanitizer"

module HandleInvalidPercentEncodingRequests

  # Rails Engine that inserts the Middleware at the top of the Rack queue
  class Engine < Rails::Engine
    initializer "handle_invalid_percent_encoding_requests.add_middleware" do |app|
      # Via http://stackoverflow.com/a/24727310/311657
      # NOTE: These must be in this order relative to each other.
      # The middleware just raises for encoding errors it doesn't cover,
      # so it must run after (= be inserted before) Rack::UTF8Sanitizer.
      app.middleware.insert 0, Middleware
      app.middleware.insert 0, Rack::UTF8Sanitizer
    end
  end

end
