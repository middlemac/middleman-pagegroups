# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'middleman-pagegroups/version'

Gem::Specification.new do |s|
  s.name        = 'middleman-pagegroups'
  s.version     = Middleman::MiddlemanPageGroups::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Jim Derry']
  s.email       = ['balthisar@gmail.com']
  s.homepage    = 'https://github.com/middlemac/middleman-pagegroups'
  s.summary     = 'Provides logical page groups and easy navigation for Middleman projects.'
  s.description = 'Provides logical page groups and easy navigation for Middleman projects.'
  s.license     = 'MIT'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
  
  # The version of middleman-core your extension depends on
  s.add_runtime_dependency('middleman-core', ['~> 4.1', '>= 4.1.6'])

  # Additional dependencies
  s.add_runtime_dependency('middleman-cli', ['~> 4.1', '>= 4.1.6'])
end
