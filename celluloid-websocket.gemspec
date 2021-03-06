# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'celluloid/websocket/version'

Gem::Specification.new do |spec|
  spec.name          = "celluloid-websocket"
  spec.version       = Celluloid::WebSocket::VERSION
  spec.authors       = ["Tinco Andringa"]
  spec.email         = ["mail@tinco.nl"]
  spec.description   = "Lets you make a websocket rack application using Celluloid."
  spec.summary       = "Lets you make a websocket rack application using Celluloid."
  spec.homepage      = "https://github.com/d-snp/celluloid-websocket"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "http"
  spec.add_dependency "websocket-driver", '>= 0.5.1'
  spec.add_dependency "rack"
  spec.add_dependency "celluloid"
  spec.add_dependency "celluloid-io"
end
