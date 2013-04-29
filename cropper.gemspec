$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "cropper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "cropper"
  s.version     = Cropper::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Cropper."
  s.description = "TODO: Description of Cropper."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.11"
  s.add_dependency "rmagick", "=2.13.1"
  s.add_dependency "eventmachine", '1.0.3'
  s.add_dependency "rufus-scheduler", '2.0.18'

  s.add_development_dependency "sqlite3"
end
