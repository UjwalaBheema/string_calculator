require_relative "lib/string_calculator/version"

Gem::Specification.new do |spec|
  spec.name          = "string_calculator"
  spec.version       = StringCalculator::VERSION
  spec.authors       = ["Your Name"]
  spec.email         = ["your_email@example.com"]

  spec.summary       = "A simple string calculator for TDD kata"
  spec.description   = "A string calculator that can add numbers in various formats as a TDD kata exercise"
  spec.homepage      = "https://github.com/username/string_calculator"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/username/string_calculator"
  spec.metadata["changelog_uri"] = "https://github.com/username/string_calculator/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # In string_calculator.gemspec
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    (Dir.glob("**/*") - Dir.glob("*.gem") - 
    Dir.glob(".git/**/*") - Dir.glob("pkg/**/*") - 
    Dir.glob("spec/**/*")).reject { |f| File.directory?(f) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end