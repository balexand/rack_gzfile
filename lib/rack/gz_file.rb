module Rack
  # Rack::GzFile behaves exactly the same as Rack::File, except that it will
  # also serve up a gzip encoding of a file, if one is available on the
  # filesystem.
  #
  # For each request, Rack::GzFile first checks the filesystem for a file with a
  # .gz extension. If one is found, the appropriate encoding headers are added
  # to the response and the gzip file is served.
  #
  # If no .gz file is found, Rack::GzFile will behave exactly like Rack::File.
  class GzFile
    def initialize(root, headers={}, default_mime = 'text/plain')
      @file_server = if Rack::File.instance_method(:initialize).arity.abs == 2
        Rack::File.new(root, headers) # for Rack < 1.5.0
      else
        Rack::File.new(root, headers, default_mime)
      end
      @default_mime = default_mime
    end

    def call(env)
      path_info = env['PATH_INFO']
      status = nil

      if env['HTTP_ACCEPT_ENCODING'] =~ /\bgzip\b/
        status, headers, body = @file_server.call(
          env.merge('PATH_INFO' => path_info + '.gz')
        )
      end

      case status
      when 200
        headers['Content-Type']     = Mime.mime_type(::File.extname(path_info), @default_mime)
        headers['Content-Encoding'] = 'gzip'
      when 304
      else
        status, headers, body = @file_server.call(env)
      end

      headers['Vary'] = 'Accept-Encoding'

      [status, headers, body]
    end
  end
end
