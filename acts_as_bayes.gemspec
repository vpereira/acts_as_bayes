# -*- encoding: utf-8 -*-
require File.expand_path('../lib/acts_as_bayes/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Victor Pereira"]
  gem.email         = ["TODO: Write your email address"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "http://gitub.com/vpereira/acts_as_bayes"
  #define version
  gem.add_dependency("mongoid")
  gem.add_dependency("minitest")
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "acts_as_bayes"
  gem.require_paths = ["lib"]
  gem.version       = ActsAsBayes::VERSION
end
