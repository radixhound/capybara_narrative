require "bundler/setup"
require "capybara"
require "capybara_narrative"
require_relative "../lib/capybara_narrative"
require 'byebug'
# require the page objects themselves

PAGE_COMPONENT_FILES = %w{pages ** *.rb}.freeze
location = File.dirname(__FILE__)
path = File.join(location, PAGE_COMPONENT_FILES)
Dir[path].each { |component|
  puts component
  require component
}

RSpec.configure do |config|
  config.include CapybaraNarrative

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
