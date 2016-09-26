# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cobertura_xml_merger/version'

Gem::Specification.new do |spec|
  spec.name          = 'cobertura_xml_merger'
  spec.version       = CoberturaXmlMerger::VERSION
  spec.authors       = ["Juan Germán Castañeda Echevarría"]
  spec.email         = ['juanger@gmail.com']

  spec.summary       = 'Merge two or more Cobertura XML reports'
  spec.homepage      = 'https://github.com/juanger/cobertura_xml_merger'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_dependency 'nokogiri', '~> 1.6'
end
