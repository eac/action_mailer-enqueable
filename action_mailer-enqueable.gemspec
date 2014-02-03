require './lib/action_mailer/enqueable/version'

Gem::Specification.new "action_mailer-enqueable", ActionMailer::Enqueable::VERSION do |gem|
  gem.authors       = ["Eric Chapweske"]
  gem.email         = ["eac@zendesk.com"]
  gem.description   = "Serialize and enqueue deliveries for existing mailers"
  gem.summary       = ""
  gem.homepage      = "https://github.com/eac/action_mailer-enqueable/"
  gem.license       = "MIT"

  gem.files         = `git ls-files lib`.split($\)

  gem.add_development_dependency 'activesupport'
  gem.add_development_dependency 'actionmailer'
  gem.add_development_dependency 'appraisal', '~> 0.5'
  gem.add_development_dependency 'debugger'
  gem.add_development_dependency 'minitest'
  gem.add_development_dependency 'minitest-rg'
end
