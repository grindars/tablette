# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tablette/version'

Gem::Specification.new do |gem|
  gem.name          = "tablette"
  gem.version       = Tablette::VERSION
  gem.authors       = ["Victor Sokolov", "Sergey Gridasov"]
  gem.email         = ["gzigzigzeo@gmail.com", "grindars@gmail.com"]
  gem.description   = %q{HTML table generator}
  gem.summary       = %q{HTML table generator}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activesupport', '>= 3'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec-html-matchers'
end
