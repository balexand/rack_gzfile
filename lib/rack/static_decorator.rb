require 'rack/static'

Rack::Static.class_eval do
  alias_method :initialize_without_gzip_file_server, :initialize
  def initialize(app, options={})
    initialize_without_gzip_file_server(app, options)

    root = options[:root] || Dir.pwd
    @file_server = Rack::GzFile.new(root, @headers)
  end
end
