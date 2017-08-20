$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "base_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "base_auth"
  s.version     = BaseAuth::VERSION
  s.authors     = ["Alexander Huber"]
  s.email       = ["alih83@gmx.de"]
  s.homepage    = "http://github."
  s.summary     = "BaseAuth, example for a service-oriented authentication engine"
  s.description = "BaseAuth, example for a service-oriented authentication engine"
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
  s.add_dependency "jwt"

  s.add_dependency "base_mailer"
end
