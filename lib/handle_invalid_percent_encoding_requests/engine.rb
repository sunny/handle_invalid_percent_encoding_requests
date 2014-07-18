require "rack/utf8_sanitizer"

module HandleInvalidPercentEncodingRequests

  class Engine < Rails::Engine
    initializer "handle_invalid_percent_encoding_requests.add_middleware" do |app|
      # Via http://stackoverflow.com/a/24727310/311657
      # NOTE: These must be in this order relative to each other.
      # The middleware just raises for encoding errors it doesn't cover,
      # so it must run after (= be inserted before) Rack::UTF8Sanitizer.
      config.middleware.insert 0, Middleware
      config.middleware.insert 0, Rack::UTF8Sanitizer
    end
  end

end
