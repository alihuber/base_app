$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "base_account/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "base_account"
  s.version     = BaseAccount::VERSION
  s.authors     = ["Alexander Huber"]
  s.email       = ["alih83@gmx.de"]
  s.homepage    = "http://github."
  s.summary     = "BaseAccount, example for a service-oriented user account engine"
  s.description = "BaseAccount, example for a service-oriented Account engine"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "bcrypt"
  s.add_dependency "rails", "5.1.3"
  s.add_dependency "sass-rails", "~> 5.0.0"
  s.add_dependency "spring"
  s.add_dependency "uglifier"
  s.add_dependency "active_interaction"
  s.add_dependency "slim-rails"
  s.add_dependency "bootstrap_form"

  s.add_dependency "base_mailer"
end
