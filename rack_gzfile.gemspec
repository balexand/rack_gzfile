# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/gz_file/version'

Gem::Specification.new do |spec|
  spec.name          = "rack_gzfile"
  spec.version       = Rack::GzFile::VERSION
  spec.authors       = ["Brian Alexander"]
  spec.email         = ["balexand@gmail.com"]
  spec.description   = %q{Rack::File meets gzip_static}
  spec.summary       = %q{Rack::File meets gzip_static}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rack"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
