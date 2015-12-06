# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sapp/version'

Gem::Specification.new do |spec|
  spec.name          = "sapp"
  spec.version       = Sapp::VERSION
  spec.authors       = ["hayduke19us"]
  spec.email         = ["hayduke19us@gmail.com"]

  spec.summary       = %q{A simple application framework for Rack.}
  spec.description   = %q{ Supports Sinatra like blocks and Rails like
                           resources.}
  spec.homepage      = "http://github.com/haydukeus/sapp"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-focus"
  spec.add_development_dependency "rack-test"

end
