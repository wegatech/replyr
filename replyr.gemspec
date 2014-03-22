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
  s.summary     = "Receive reply emails with Rails"
  s.description = "Receive and parse incoming reply emails with ease"

  s.files       = Dir["{app,config,lib,test}/**/*", "[A-Z]*", "init.rb"] - ["Gemfile.lock"]
  s.require_path = "lib"

  s.add_dependency 'mailman', '>= 0.7.0'
  s.add_dependency 'listen', '< 2.0.0' # mailman does not work with listen >2.0.0. wating for new release
  s.add_dependency 'daemons'
  
  s.add_development_dependency 'rails', '~> 3.2.13'
  s.add_development_dependency 'minitest', '< 5.0.0'
  s.add_development_dependency "sqlite3"
  
  s.required_rubygems_version = ">= 1.3.4"
end
