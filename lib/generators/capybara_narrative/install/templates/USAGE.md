# Capybara Narrative Page Objects Guide

This guide describes how to create page objects for use with the Capybara Narrative framework.

## Basic Structure

A page object follows this general structure:

```ruby
module CapybaraNarrative
  class SomePage < Page
    with_page_url '/path/to/page'

    # Element and form field mappings
    form_label :field_name, label: 'Field Label'
    map_label :button_name, 'Button Text'

    # Element methods
    def main_heading
      css('h1')
    end

    def specific_element
      css('.element-class')
    end
  end
end
```

## Required Components

1. **Module**: All page objects must be in the `CapybaraNarrative` module
2. **Class Name**: Must end with `Page` (e.g., `HomePage`, `SearchResultsPage`)
3. **Inheritance**: Must inherit from `Page`
4. **URL**: Use `with_page_url` to define the page's URL path

## Label Mapping Methods

### Form Labels

Form labels map symbolic names to form fields:

```ruby
form_label :email, label: 'Email Address'
form_label :password, label: 'Password'
```

This allows you to use the `fill_form` method in tests:

```ruby
fill_form(
  email: 'user@example.com',
  password: 'secret123'
)
```

### Custom Form Interactions

For form fields that need special handling, define a method:

```ruby
form_label :birthdate, method: :pick_date

def pick_date(date)
  # Custom implementation for date picker
  find('.date-picker').click
  # More implementation...
end
```

### Button/Element Labels

Map buttons and other clickable elements:

```ruby
map_label :submit_button, 'Sign In'
map_label :cancel_link, 'Cancel'
```

This allows you to use them in tests:

```ruby
click_on :submit_button
```

## Element Methods

Define methods that return Capybara elements:

```ruby
def error_message
  css('.error-message')
end

def result_titles
  css('.result-title').map(&:text)
end

def items_count
  find('.count').text.to_i
end
```

These can be used in tests:

```ruby
expect(current_page.error_message.text).to eq('Invalid credentials')
expect(current_page.result_titles).to include('Expected Item')
expect(current_page.items_count).to be > 5
```

## Page Verification

Add methods to verify the current page:

```ruby
def which_panda
  if css('.panda-type').text.include?('Red Rose')
    'red_rose'
  else
    'pink_petunia'
  end
end
```

## Best Practices

1. **Keep it simple**: Focus on readability and maintainability
2. **Single responsibility**: Each page object should represent one page
3. **Descriptive methods**: Use clear and consistent naming
4. **Reuse patterns**: Follow patterns used in existing page objects
5. **Test-specific concerns**: Only include elements and methods needed for tests