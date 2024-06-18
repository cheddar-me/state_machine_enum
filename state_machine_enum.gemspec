# frozen_string_literal: true

require_relative "lib/state_machine_enum/version"

Gem::Specification.new do |spec|
  spec.name = "state_machine_enum"
  spec.version = StateMachineEnum::VERSION
  spec.authors = ["Julik Tarkhanov", "Sebastian van Hesteren", "Stanislav Katkov"]
  spec.email = ["julik@cheddar.me", "sebastian@cheddar.me", "skatkov@cheddar.me"]

  spec.summary = "Define possible state transitions for a field"
  spec.description = "Concern that makes it easy to define and enforce possibe state transitions for a field/object"
  spec.homepage = "https://cheddar.me"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/cheddar-me/state_machine_enum"
  spec.metadata["changelog_uri"] = "https://github.com/cheddar-me/state_machine_enum/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 7"
  spec.add_development_dependency "sqlite3", "~> 1.4"
  spec.add_development_dependency "activerecord", "~> 7"
end
