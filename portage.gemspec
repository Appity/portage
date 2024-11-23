require_relative 'lib/portage/version'

Gem::Specification.new do |spec|
  spec.name = 'portage'
  spec.version = Portage.version
  spec.authors = [ 'Scott Tadman' ]
  spec.email = [ 'tadman@appity.studio' ]

  spec.summary = %q{Thread pools for Async code}
  spec.description = %q{Run background threads that are treated as Async tasks}
  spec.homepage = 'https://github.com/appity/portage'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org/'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/appity/portage'
  spec.metadata['changelog_uri'] = 'https://github.com/appity/portage'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = %w[ lib ]

  spec.add_dependency 'async'
end
