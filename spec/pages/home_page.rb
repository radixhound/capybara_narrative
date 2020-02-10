module CapybaraNarrative
  class HomePage < Page
    with_page_url '/home.html'
    form_label :search, label: 'Search for something'
    with_labels submit_button: 'Submit'

    def main_heading
      css('h1')
    end
  end
end