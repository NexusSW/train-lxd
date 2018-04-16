# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'train/lxd/version'

Gem::Specification.new do |spec|
  spec.name          = 'train-lxd'
  spec.version       = Train::Lxd::VERSION
  spec.authors       = ['Sean Zachariasen']
  spec.email         = ['thewyzard@hotmail.com']

  spec.summary       = 'LXD Driver for Train'
  spec.homepage      = 'https://github.com/NexusSW/train-lxd'
  spec.license       = 'Apache-2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'train', '~> 0.12' # TODO: temporary.  Get my gem stable and working on < 1.0 and then we'll bump to 1.0 & fix whatever needed (1.0 is brand new)
  spec.add_dependency 'lxd-common', '~> 0.9'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'kitchen-lxd_sling', '~> 0.5' # transport injection version
  spec.add_development_dependency 'kitchen-inspec', '~> 0.22', '<= 0.23' # transport injection version
  spec.add_development_dependency 'berkshelf'
end
