# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fiscaly/version'

Gem::Specification.new do |spec|
  spec.name          = "fiscaly"
  spec.version       = Fiscaly::VERSION
  spec.authors       = ["Yoshikazu Kaneta"]
  spec.email         = ["kaneta@sitebridge.co.jp"]
  spec.summary       = %q{Financial date class for ruby}
  spec.description   = %q{Financial date class for ruby}
  spec.homepage      = "https://github.com/kanety/fiscaly"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", ">= 5.0"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
