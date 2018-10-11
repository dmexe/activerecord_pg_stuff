# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'activerecord_pg_stuff/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord_pg_stuff"
  spec.version       = ActiveRecordPgStuff::VERSION
  spec.authors       = ["Dmitry Galinsky"]
  spec.email         = ["dima.exe@gmail.com"]
  spec.description   = %q{ Adds support for working with temporary tables and pivot tables (PostgreSQL only) }
  spec.summary       = %q{ Adds support for working with temporary tables and pivot tables (PostgreSQL only) }
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord", "~> 5.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "appraisal"
end
