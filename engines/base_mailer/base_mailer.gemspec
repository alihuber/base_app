$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "base_mailer/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "base_mailer"
  s.version     = BaseMailer::VERSION
  s.authors     = ["Alexander Huber"]
  s.email       = ["alih83@gmx.de"]
  s.homepage    = "http://github."
  s.summary     = "BaseMailer, an example of a generic mailer engine"
  s.description = "BaseMailer, an example of a generic mailer engine"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 5.1.3"
end
