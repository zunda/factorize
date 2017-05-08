# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'factorize/version'

Gem::Specification.new do |spec|
  spec.name          = "factorize"
  spec.version       = Factorize::VERSION
  spec.authors       = ["zunda"]
  spec.email         = ["zundan@gmail.com"]

  spec.summary       = %q{A scalable library to factorize sets of integers.}
  spec.description   = %q{A library to factorize sets of integers. This library can be scaled through a Redis server.}
  spec.homepage      = "https://github.com/zunda/factorize"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"

  spec.add_runtime_dependency 'redis', '~> 3.3', '>= 3.3.1'
  spec.add_runtime_dependency "fakeredis"
  spec.add_runtime_dependency 'sidekiq', '~> 5.0'
  spec.add_runtime_dependency 'redis-objects', '~> 1.3'
end
