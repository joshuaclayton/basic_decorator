# -*- encoding: utf-8 -*-
require File.expand_path('../lib/basic_decorator/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Josh Clayton']
  gem.email         = ['joshua.clayton@gmail.com']
  gem.description   = %q{Decoration in Ruby should be easy}
  gem.description   = %q{Decoration in Ruby should be easy. With BasicDecorator, it is.}
  gem.homepage      = 'https://github.com/joshuaclayton/basic_decorator'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'basic_decorator'
  gem.require_paths = ['lib']
  gem.version       = BasicDecorator::VERSION

  gem.add_development_dependency('rspec', '~> 2.0')
  gem.add_development_dependency('money', '~> 5.0')
end
