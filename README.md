Handle Invalid Percent Encoding Requests
=======================================

Rails Engine that protects your app against malformed requests.

This middleware renders a 400 error instead of raising exceptions for the
following errors:

- `invalid byte sequence in UTF-8`
- `string contains null byte`

Installation
------------

In your Rails app, add these lines to your `Gemfile`:

```rb
# Helps against "invalid byte sequence" exceptions.
gem "handle_invalid_percent_encoding_requests"
```

Then type `bundle install`.

See also
--------

See also [Ruby on Rails “invalid byte sequence in UTF-8” due to
bot](http://stackoverflow.com/q/24648206/311657) on StackOverflow.
