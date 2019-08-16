$:.push File.expand_path(File.join("..", "lib"), __FILE__)
require "active_model/changelog/version"

Gem::Specification.new do |spec|
  spec.name = "blank-gem"
  spec.version = Blankgem::VERSION
  spec.authors = ["Kurtis Rainbolt-Greene"]
  spec.email = ["kurtis@rainbolt-greene.online"]
  spec.summary = %q{A way to track changes to ActiveModel::Model-interfaces}
  spec.description = spec.summary
  spec.homepage = "http://krainboltgreene.github.io/active_model-changelog"
  spec.license = "ISC"

  spec.files = Dir[File.join("lib", "**", "*"), "LICENSE", "README.md", "Rakefile"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "1.15.4"
  spec.add_development_dependency "rspec", "3.7.0"
  spec.add_development_dependency "rake", "12.2.1"
  spec.add_development_dependency "pry", "0.11.2"
  spec.add_development_dependency "pry-doc", "0.11.1"
  spec.add_runtime_dependency "activesupport", "5.1.6"
  spec.add_runtime_dependency "activemodel", "5.1.6"
end
