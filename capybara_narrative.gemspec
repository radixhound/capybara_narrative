require_relative 'lib/capybara_narrative/version'

Gem::Specification.new do |spec|
  spec.name          = 'capybara_narrative'
  spec.version       = CapybaraNarrative::VERSION
  spec.authors       = ['Christopher Dwan']
  spec.email         = ['chris@radnine.com']

  spec.summary       = 'Narrative driven page object library for Capybara'
  spec.description   = "Page objects define an interface to your page structure so your tests don't have to be tightly coupled."
  spec.homepage      = 'https://github.com/radixhound/capybara_narrative'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['allowed_push_host'] = 'http://mygemserver.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/radixhound/capybara_narrative'
  spec.metadata['changelog_uri'] = 'https://github.com/radixhound/capybara_narrative/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 5.0'
  spec.add_dependency 'capybara', '>= 3.0'
  spec.add_dependency 'railties', '>= 5.0'

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'capybara-playwright-driver', '~> 0.4'
  spec.add_development_dependency 'playwright-ruby-client', '~> 1.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
