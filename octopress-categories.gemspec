# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'octopress-categories/version'

Gem::Specification.new do |spec|
  spec.name          = "octopress-categories"
  spec.version       = Octopress::Categories::VERSION
  spec.authors       = ["Patrice Brend'amour"]
  spec.email         = ["patrice@brendamour.net"]
  spec.summary       = %q{Category pages for Octopress and Jekyll pages.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split("\n").grep(%r{^(bin\/|lib\/|assets\/|changelog|readme|license)}i)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "octopress-ink", ">= 1.0.0.rc"
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "octopress"
  spec.add_development_dependency "clash"
  spec.add_development_dependency "octopress-multilingual"

  if RUBY_VERSION >= "2"
    spec.add_development_dependency "octopress-debugger"
  end
end
