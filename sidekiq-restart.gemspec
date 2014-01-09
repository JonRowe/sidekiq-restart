# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/restart/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-restart"
  spec.version       = Sidekiq::Restart::VERSION
  spec.authors       = ["Jon Rowe"]
  spec.email         = ["hello@jonrowe.co.uk"]
  spec.license       = "MIT"
  spec.description   = %q{Allows manual restarts of Sidekiq workers.}
  spec.summary       = %q{Allows manual restarts of Sidekiq workers via the Web UI.}
  spec.homepage      = "https://github.com/JonRowe/sidekiq-restart/"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "sidekiq", "~> 2.17.2"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rack-test"
  spec.add_development_dependency "rspec",   "~> 3.0.0.beta1"
end
