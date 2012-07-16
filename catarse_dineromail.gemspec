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

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency "rails", "~> 3.2.6"
  s.add_dependency "dinero_mail_checkout"
  s.add_dependency "dinero_mail_ipn"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "database_cleaner"
end
