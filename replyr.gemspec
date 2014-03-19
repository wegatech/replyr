$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "replyr/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "replyr"
  s.version     = Replyr::VERSION
  s.authors     = ["Philipp Wüllner"]
  s.email       = ["wursttheke@me.com"]
  s.homepage    = "http://www.github.com/wursttheke/replyr"
  s.summary     = "Receive emails with Rails"
  s.description = "Receive and parse incoming emails with ease"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'em-http-request'
  #s.add_dependency 'mailman', git: 'git://github.com/titanous/mailman'
  s.add_dependency 'daemons'
  
  s.add_development_dependency 'rails', '~> 3.2.13'
  s.add_development_dependency 'minitest', '< 5.0.0'
  s.add_development_dependency "sqlite3"
end
