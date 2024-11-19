require 'bundler/setup'
require 'capybara'
require 'capybara/rspec' # or else video recording doesn't work
require 'capybara-playwright-driver'
require 'byebug'
require 'fileutils'

# Ensure the tmp/videos directory exists
FileUtils.mkdir_p(File.join(File.dirname(__FILE__), '..', 'tmp', 'videos'))

# export PLAYWRIGHT_CLI_VERSION=$(bundle exec ruby -e 'require "playwright"; puts Playwright::COMPATIBLE_PLAYWRIGHT_VERSION.strip')
# yarn add -D "playwright@$PLAYWRIGHT_CLI_VERSION"
# yarn run playwright install

# require the page objects themselves
PAGE_COMPONENT_FILES = %w[pages ** *.rb].freeze
path = File.join(File.dirname(__FILE__), PAGE_COMPONENT_FILES)
Dir[path].each { |component| require component }

# Capybara configuration for setting up the test rack app
# This uses Rack::Directory to fetch the files from test_sites/basic_html.
test_app_root = File.expand_path(
  File.join(File.dirname(__FILE__), '..', 'test_sites', 'basic_html')
)

Capybara.register_driver :playwright do |app|
  Capybara::Playwright::Driver.new(app,
    browser_type: ENV["PLAYWRIGHT_BROWSER"]&.to_sym || :chromium,
    headless: (false unless ENV["CI"] || ENV["PLAYWRIGHT_HEADLESS"]),
  ).tap do |driver|
    driver.on_save_screenrecord do |video_path|
      # Process the video, e.g., save it to a specific location or attach it to a report
      FileUtils.mv(video_path, File.join(File.dirname(__FILE__), '..', 'tmp', 'videos', "#{RSpec.current_example.description}.webm"))
    end
  end
end

Capybara.app = Rack::Builder.new { run Rack::Directory.new(test_app_root) }
Capybara.configure do |config|
  config.run_server = true
  config.default_driver = :playwright
end
Capybara.save_path = 'tmp/capybara'


RSpec.configure do |config|
  config.include Capybara::DSL

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
