# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hunting/version'

Gem::Specification.new do |spec|
  spec.name          = "hunting"
  spec.version       = Hunting::VERSION
  spec.authors       = ["Andy Weidner"]
  spec.email         = ["metaweidner@gmail.com"]

  spec.summary       = %q{Access digital collections through the CONTENTdm API.}
  spec.description   = %q{Hunting is a Ruby wrapper for the CONTENTdm API. Quickly 'Scout' your Repository, 'Hunt' for metadata in your Collections, and 'Trap' individual Digital Objects.}
  spec.homepage      = "https://github.com/uhlibraries-digital/hunting"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # spec.add_dependency 'yaml'
  # spec.add_dependency 'open-uri'
  spec.add_dependency 'json', "~> 1.7"
  spec.add_dependency 'nokogiri', "~> 1.5"
  spec.add_dependency 'ruby-progressbar', "~> 1.8"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
