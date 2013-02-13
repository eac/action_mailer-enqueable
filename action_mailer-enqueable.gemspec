# -*- encoding: utf-8 -*-
require File.expand_path('../lib/action_mailer/enqueable/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Eric Chapweske"]
  gem.email         = ["eac@zendesk.com"]
  gem.description   = "Serialize and enqueue deliveries for existing mailers"
  gem.summary       = %q{}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "action_mailer-enqueable"
  gem.require_paths = ["lib"]
  gem.version       = ActionMailer::Enqueable::VERSION

  gem.add_development_dependency 'activesupport', '2.3.16'
  gem.add_development_dependency 'actionmailer',  '2.3.16'
end
