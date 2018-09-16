
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gamey/version"

Gem::Specification.new do |spec|
  spec.name          = "gamey"
  spec.version       = Gamey::VERSION
  spec.authors       = ["Kyle Dayton"]
  spec.email         = ["Kyle Dayton <kyle@grol.ly>"]

  spec.summary       = %q{A small utility for building games in ruby}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/kyledayton/gamey"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_dependency 'gosu', '~> 0.13'
end
