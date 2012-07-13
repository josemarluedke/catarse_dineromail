$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "catarse_dineromail/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "catarse_dineromail"
  s.version     = CatarseDineromail::VERSION
  s.authors     = ["Josemar Davi Luedke"]
  s.email       = ["josemarluedke@gmail.com"]
  s.homepage    = "http://github.com/josemarluedke/catarse-dineromail"
  s.summary     = "Dineromail integration with Catarse"
  s.description = "Dineromail integration with Catarse crowdfunding platform"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.6"
  # s.add_dependency "jquery-rails"
end
