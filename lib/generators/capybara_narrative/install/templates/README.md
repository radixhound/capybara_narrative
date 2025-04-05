Capybara Narrative has been installed!

Files created:
  - spec/playwright_helper.rb - Helper file to configure Playwright and load page objects
  - spec/pages/ - Directory for your page object files
  - spec/pages/USAGE.md - Guide on how to create page objects

Next steps:

1. Ensure you have Playwright installed:
   playwright install

2. Install the correct Playwright version as a dev dependency:
   export PLAYWRIGHT_CLI_VERSION=$(bundle exec ruby -e 'require "playwright"; puts Playwright::COMPATIBLE_PLAYWRIGHT_VERSION.strip')
   yarn add -D "playwright@$PLAYWRIGHT_CLI_VERSION"
   yarn run playwright install

3. Create your first page object in spec/pages/home_page.rb:

   module CapybaraNarrative
     class HomePage < Page
       with_page_url '/'

       def main_heading
         css('h1')
       end
     end
   end

4. Write your first test in spec/playwright/example_spec.rb:

   require 'playwright_helper'

   RSpec.describe 'Example', type: :feature do
     load_pages(home_page: 'HomePage')

     it 'visits the homepage' do
       home_page.visit do
         expect(current_page.main_heading.text).to eq('Welcome')
       end
     end
   end

For more information, see spec/pages/USAGE.md