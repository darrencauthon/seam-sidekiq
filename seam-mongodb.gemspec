# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'seam/active_record/version'

Gem::Specification.new do |spec|
  spec.name          = "seam-active_record"
  spec.version       = Seam::ActiveRecord::VERSION
  spec.authors       = ["Darren Cauthon"]
  spec.email         = ["darren@cauthon.com"]
  spec.description   = %q{Active Record support for seam}
  spec.summary       = %q{Active Record support for seam}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json"
  spec.add_runtime_dependency "activesupport", "~> 3.2"
  spec.add_runtime_dependency "i18n"
  spec.add_runtime_dependency "seam"
  spec.add_development_dependency 'subtle'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "contrast"
  spec.add_development_dependency "timecop"

end
