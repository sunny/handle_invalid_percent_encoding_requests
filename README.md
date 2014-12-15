Handle Invalid Percent Encoding Requests
=======================================

Rails Engine that renders 400 error whenever a request's
percent-encoding is malformed and raises the following error:

    invalid byte sequence in UTF-8

This happens notably a lot for the chinese [EasouSpider](http://www.easou.com/search/spider.html).

See http://stackoverflow.com/q/24648206/311657

Install
-------

In your Rails app, add this line to your `Gemfile`:

```rb
gem "handle_invalid_percent_encoding_requests"
```

Then type `bundle`.

Rails 4.2
---------

This will probably be fixed in Rails 4.2 by the following commit:
https://github.com/rails/rails/commit/3fc561a1f71edf1c2bae695cafa03909d24a5ca3
