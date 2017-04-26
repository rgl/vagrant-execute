$:.unshift File.expand_path("../lib", __FILE__)

require "vagrant-execute/version"

Gem::Specification.new do |gem|
  gem.name          = "vagrant-execute"
  gem.version       = VagrantPlugins::Execute::VERSION
  gem.platform      = Gem::Platform::RUBY
  gem.license       = "LGPLv3"
  gem.authors       = "Rui Lopes"
  gem.email         = "rgl@ruilopes.com"
  gem.homepage      = "https://github.com/rgl/vagrant-execute"
  gem.description   = "Vagrant plugin for executing commands."
  gem.summary       = "Vagrant plugin for executing commands."
  gem.files         = Dir.glob("lib/**/*").reject {|p| File.directory? p}
  gem.require_path  = "lib"

  gem.add_development_dependency "rake"
end
