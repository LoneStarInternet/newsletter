$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "newsletter/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |gem|
  gem.name          = "newsletter"
  gem.version       = Newsletter::VERSION
  gem.authors       = ["Lone Star Internet"]
  gem.email         = ["biz@lone-star.net"]
  gem.description   = %q{Newletter templating and management system.}
  gem.summary       = %q{ewletter templating and management system.}
  gem.homepage      = "http://ireach.com"

  gem.add_dependency "rails", "~>3.2"
  gem.add_dependency "mini_magick"
  gem.add_dependency "will_paginate"
  gem.add_dependency 'carrierwave'
  gem.add_dependency "delayed_job", "~>4"
  gem.add_dependency "dynamic_form", "~>1.1"
  gem.add_dependency 'nested_form'
  gem.add_dependency 'curb'
  gem.add_dependency 'acts_as_list'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
