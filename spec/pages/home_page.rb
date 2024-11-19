# frozen_string_literal: true

module CapybaraNarrative
  # HomePage defines the structure of the home page
  class HomePage < Page
    with_page_url '/home.html'
    form_label :search, label: 'Search for something'
    map_label :submit_button, 'Submit'

    def main_heading
      css('h1')
    end
  end
end
