# frozen_string_literal: true

require_relative 'lib/rspec/pipeline/version'

Gem::Specification.new do |spec|
  spec.name          = 'rspec-pipeline'
  spec.version       = RSpec::Pipeline::VERSION
  spec.authors       = ['Thiago Marinho']
  spec.email         = ['eu@thiagomarinho.net']

  spec.summary       = 'RSpec-Pipeline helps you to write and test your pipeline manifests'
  spec.homepage      = 'https://github.com/thiagomarinho/rspec-pipeline'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  # spec.metadata['allowed_push_host'] = 'TODO: Set to your gem server 'https://example.com''

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/thiagomarinho/rspec-pipeline'
  spec.metadata['changelog_uri'] = 'https://github.com/thiagomarinho/rspec-pipeline/CHANGELOG.md'

  spec.files = Dir['CHANGELOG.md', 'LICENSE.txt', 'README.md', 'lib/**/*', 'bin/**/*']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency 'example-gem', '~> 1.0'

  spec.add_runtime_dependency 'byebug'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
