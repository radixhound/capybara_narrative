# frozen_string_literal: true

module CapybaraNarrative
  # HomePage defines the structure of the home page
  class CheckoutPage < Page
    with_page_url '/checkout.html'
    form_label :card_number, method: :card_number
    form_label :month, method: :select_month
    form_label :year, method: :select_year
    form_label :cvv, label: 'CVV'
    with_labels checkout: 'Checkout'

    def main_heading
      css('h1')
    end

    def location
      current_url
    end

    private

    def card_number(value)
      fill_in 'Card Number', with: value
    end

    def select_month(value)
      find("select[name='Month']").select(value)
    end

    def select_year(value)
      find("select[name='Year']").select(value)
    end
  end
end
