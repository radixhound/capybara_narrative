require 'bundler/setup'
require 'capybara'

# capybara/dsl is required for the automatic inclusion of page objects
#  as methods like HomePage as home_page
require 'capybara/dsl'
require 'capybara_narrative'
require 'byebug'

# require the page objects themselves
PAGE_COMPONENT_FILES = %w[pages ** *.rb].freeze
path = File.join(File.dirname(__FILE__), PAGE_COMPONENT_FILES)
Dir[path].each { |component| require component }

# Capybara configuration for setting up the test rack app
# This usese Rack::Directory to fetch the files from test_sites/basic_html.
test_app_root = File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'test_sites', 'basic_html')
)
Capybara.app = Rack::Builder.new { run Rack::Directory.new(test_app_root) }
Capybara.configure { |config| config.run_server = true }

RSpec.configure do |config|
  config.include CapybaraNarrative
  config.include Capybara::DSL

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
