$:.push File.expand_path("../lib", __FILE__)

require "handle_invalid_percent_encoding_requests/version"

Gem::Specification.new do |s|
  s.name        = "handle_invalid_percent_encoding_requests"
  s.version     = HandleInvalidPercentEncodingRequests::VERSION
  s.authors     = ["Sunny Ripert"]
  s.email       = ["sunny@sunfox.org"]
  s.homepage    = "http://github.com/sunny/handle_invalid_percent_encoding_requests"
  s.summary     = "Handle invalid percent in encoding from requests in Rails"
  s.description = "Render 400 error whenever a request's %-encoding is malformed"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.1.4"

  # s.add_development_dependency "rspec-rails"
  # s.add_development_dependency "combustion"
end
