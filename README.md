# CapybaraNarrative

CapybaraNarrative is a page objects library for capybara. The goal is to provide a clean syntax that doesn't require learning very much of a new DSL and to primarily use the existing capybara syntax for tests. It's called 'narrative' because it allows pages that you visit to drive the narrative of your tests and puts the action at the start of each line as much as possible.

```ruby
home_page.visit do
  fill_form(search: 'Things that make ya go hmmm')
  click_on :search_button
end
```

## Installation

Add these lines to your application's Gemfile:

```ruby
group :test do
  gem 'capybara_narrative'
  gem 'capybara-playwright-driver'
end
```

And then execute:

```bash
$ bundle install
```

### Playwright Setup

To set up Playwright for testing, you need to:

1. Install the Playwright browser binaries:

```bash
$ playwright install
```

2. Add Playwright as a development dependency with the correct version:

```bash
$ export PLAYWRIGHT_CLI_VERSION=$(bundle exec ruby -e 'require "playwright"; puts Playwright::COMPATIBLE_PLAYWRIGHT_VERSION.strip')
$ yarn add -D "playwright@$PLAYWRIGHT_CLI_VERSION"
$ yarn run playwright install
```

### Rails Generator

If you're using Rails, you can use the provided generator to set up the necessary files:

```bash
$ rails generate capybara_narrative:install
```

This will create:
- `spec/playwright_helper.rb` - Helper file for Playwright configuration
- `spec/pages` directory - For your page object files
- `spec/pages/USAGE.md` - Documentation on how to create page objects

## Usage

### Creating Page Objects

Create a page object class for each page in your application:

```ruby
# spec/pages/home_page.rb
module CapybaraNarrative
  class HomePage < Page
    with_page_url '/home.html'
    form_label :search, label: 'Search for something'
    map_label :submit_button, 'Submit'

    def main_heading
      css('h1')
    end
  end
end
```

### Writing Tests

In your RSpec tests, load the page objects and use them:

```ruby
# spec/playwright/example_spec.rb
require 'playwright_helper'

RSpec.describe 'Example Test', type: :feature do
  load_pages(
    home_page: 'HomePage',
    results_page: 'SearchResultsPage'
  )

  it 'searches for an item' do
    home_page.visit do
      expect(current_page.main_heading.text).to eq('Welcome')
      fill_form(search: 'Example')
      click_on :submit_button
    end

    results_page do
      expect(current_page).to be_current_page
      expect(current_page.results_count).to be > 0
    end
  end
end
```

### Page Object DSL

CapybaraNarrative provides several DSL methods for your page objects:

- `with_page_url '/path'` - Define the URL for the page
- `form_label :field_name, label: 'Label Text'` - Map a form field to a label
- `map_label :element_name, 'Button Text'` - Map an element to its text
- Method definitions for page elements like `def heading() css('h1') end`

### Testing Methods

Within your tests, you can use these methods:

- `fill_form(field: 'value')` - Fill form fields by their mapped names
- `click_on :element_name` - Click on mapped elements
- `click_element :method_name, text: 'Example'` - Click elements with options
- Standard Capybara methods like `expect(page).to have_content('text')`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/capybara_narrative. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/capybara_narrative/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CapybaraNarrative project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/capybara_narrative/blob/master/CODE_OF_CONDUCT.md).
