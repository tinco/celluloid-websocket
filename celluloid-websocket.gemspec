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
  spec.summary       = "This is basically a small wrapper around Tony Arcieri's Reel::Websocket class."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency "reel", "= 0.3"
end
