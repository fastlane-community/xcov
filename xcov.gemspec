# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "xcov/version"

Gem::Specification.new do |spec|
  spec.name          = "xcov"
  spec.version       = Xcov::VERSION
  spec.authors       = ["Carlos Vidal"]
  spec.email         = ["nakioparkour@gmail.com"]
  spec.summary       = Xcov::DESCRIPTION
  spec.description   = Xcov::DESCRIPTION
  spec.homepage      = "https://github.com/nakiostudio/xcov"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.0.0"

  spec.files = Dir["lib/**/*"] + Dir["views/*"] + Dir["assets/**/*"] + %w(bin/xcov README.md LICENSE)

  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'fastlane', '>= 2.82.0', '< 3.0.0'
  spec.add_dependency 'slack-notifier'
  spec.add_dependency 'xcodeproj'
  spec.add_dependency 'terminal-table'
  spec.add_dependency 'multipart-post'
  spec.add_dependency 'xcresult', '~> 0.1.1'

  # Development only
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "byebug"
end
