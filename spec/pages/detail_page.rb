# frozen_string_literal: true

module CapybaraNarrative
  # HomePage defines the structure of the home page
  class DetailPage < Page
    with_page_url '/pandas/:id'
    form_label :quantity, label: 'Quantity'
    map_label :add_to_cart, 'Add To Cart'

    def main_heading
      css('h1')
    end

    def which_panda
      current_url =~ /(\w+)\.html$/
      Regexp.last_match(1)
    end
  end
end
