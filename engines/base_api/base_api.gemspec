$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "base_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "base_api"
  s.version     = BaseApi::VERSION
  s.authors     = ["Alexander Huber"]
  s.email       = ["alih83@gmx.de"]
  s.homepage    = "http://github."
  s.summary     = "BaseApi, example for a service-oriented api engine"
  s.description = "BaseApi, example for a service-oriented api engine"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "5.1.3"
  s.add_dependency "spring"
  s.add_dependency "base_auth"
end
