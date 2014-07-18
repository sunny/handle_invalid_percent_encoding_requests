module HandleInvalidPercentEncodingRequests

  class Engine < Rails::Engine
    initializer "handle_invalid_percent_encoding_requests.add_middleware" do |app|
      app.middleware.use HandleInvalidPercentEncodingRequests::Middleware
    end
  end

end
