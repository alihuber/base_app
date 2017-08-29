$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "base_admin/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "base_admin"
  s.version     = BaseAdmin::VERSION
  s.authors     = ["Alexander Huber"]
  s.email       = ["alih83@gmx.de"]
  s.homepage    = "http://github."
  s.summary     = "BaseAdmin, example for a service-oriented admin engine"
  s.description = "BaseAdmin, example for a service-oriented admin engine"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "bcrypt"
  s.add_dependency "rails", "5.1.3"
  s.add_dependency "sass-rails", "~> 5.0.0"
  s.add_dependency "spring"
  s.add_dependency "uglifier"
  s.add_dependency "slim-rails"
end
