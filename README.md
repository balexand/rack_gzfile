[![Build Status](https://travis-ci.org/balexand/rack_gzfile.png)](https://travis-ci.org/balexand/rack_gzfile)

# RackGzfile

By default, `rake assets:precompile` generates gzipped versions of certain types of files. Servers (like Nginx with the GzipStatic module) can then serve these gzipped assets so they can get the reduced bandwidth of gzip without needing to compress the file on every request. [This pull request](https://github.com/rack/rack/pull/479) will hopefully bring this functionality to Rack. In the meantime, this gem can be used.

## Installation

Add this line to your application's Gemfile:

    gem 'rack_gzfile'

And then execute:

    $ bundle

## Usage

`Rack::GzFile` can be used as a drop-in replacement for [`Rack::File`](https://github.com/rack/rack/blob/master/lib/rack/file.rb).

### Usage with `Rack::Static`

By default, this gem monkey patches `Rack::Static` to use gzip. All that you need to do is require the gem.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
