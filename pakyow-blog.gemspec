require File.expand_path('../lib/pakyow/blog/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name                   = 'pakyow-blog'
  spec.summary                = 'Pakyow Blog'
  spec.description            = 'Blog Plugin for Pakyow'
  spec.authors                = ['Bryan Powell']
  spec.email                  = 'bryan@metabahn.com'
  spec.homepage               = 'http://pakyow.org'
  spec.version                = Pakyow::Blog::VERSION
  spec.require_path           = 'lib'
  spec.files                  = Dir['CHANGELOG.md', 'README.md', 'LICENSE', 'lib/**/*']
  spec.license                = 'LGPL-3.0'
  spec.required_ruby_version  = '>= 2.0.0'

  spec.add_dependency('pakyow', '~> 0.10')
  spec.add_dependency('pakyow-slim', '~> 1.0')
  spec.add_dependency('pakyow-assets', '~> 0.1')
  spec.add_dependency('pakyow-console', '~> 0.1')
end
