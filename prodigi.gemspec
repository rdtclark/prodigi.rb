# frozen_string_literal: true

require_relative "lib/prodigi/version"

Gem::Specification.new do |spec|
  spec.name = "prodigi"
  spec.version = Prodigi::VERSION
  spec.authors = ["Robin Clark"]
  spec.email = ["robindtclark@gmail.com"]

  spec.summary = "Ruby bindings for Prodigi API"
  spec.description = "Ruby bindings for the Prodigi API. Prodigi API can be found here https://www.prodigi.com/print-api"
  spec.homepage = "https://github.com/rdtclark/prodigi.rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/rdtclark/prodigi.rb"
  spec.metadata["changelog_uri"] = "https://github.com/rdtclark/prodigi/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", "~> 1.8"
  spec.add_dependency "faraday_middleware", "~> 1.2"
  spec.add_development_dependency 'pry'
end
