# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/slimlint/version'

Gem::Specification.new do |spec|
  spec.name          = 'guard-slim_lint'
  spec.version       = Guard::SlimLintVersion::VERSION
  spec.authors       = ['Yasuhiko Katoh']
  spec.email         = ['toyasyu@gmail.com']

  spec.summary       = 'Guard plugin for Slim-Lint'
  spec.description   = 'Guard::SlimLint automatically runs Slim Lint tools.'
  spec.homepage      = 'https://github.com/yatmsu/guard-slim-lint'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.5.9'

  spec.add_dependency 'guard', '~> 2.2'
  spec.add_dependency 'guard-compat', '~> 1.2'
  spec.add_runtime_dependency 'slim_lint', '>= 0.17.0'

  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rspec', '~> 3.7.0'
end
