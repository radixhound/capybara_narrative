require 'rails/generators/base'

module CapybaraNarrative
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('install/templates', __dir__)

      desc 'Installs Capybara Narrative with Playwright setup'

      def create_playwright_helper
        template 'playwright_helper.rb', 'spec/playwright_helper.rb'
      end

      def create_pages_directory
        empty_directory 'spec/pages'
      end

      def create_usage_file
        template 'USAGE.md', 'spec/pages/USAGE.md'
      end

      def show_readme
        readme 'README' if behavior == :invoke
      end
    end
  end
end
