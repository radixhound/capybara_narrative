require 'spec_helper'

RSpec.describe 'Checkout Flow', type: :feature do
  load_pages(
    home_page: 'HomePage',
    results_page: 'SearchResultsPage',
    detail_page: 'DetailPage',
    checkout_page: 'CheckoutPage'
  )

  it 'navigates from the homepage to checkout' do
    home_page.visit do
      expect(current_page.main_heading.text).to eq('Pandas Love Teapots')

      fill_form(search: 'Flowers')
      click_on :submit_button
    end

    results_page do
      expect(current_page).to be_current_page
      expect(current_page.main_heading.text).to eq('Search Results')
      expect(current_page.result_titles).to include('Pink Petunia Panda', 'Red Rose Panda')

      click_element :result_title, text: 'Pink Petunia Panda'
    end

    detail_page do
      # TODO: how do we check that this is the page we're expecting
      # to be on? It might not even be a valuable test, but potentially
      # it could help?
      expect(current_page.which_panda).to eq('pink_petunia')
      expect(current_page.main_heading.text).to eq('Pink Petunia Panda')

      fill_form(quantity: 20)
      click_on :add_to_cart
    end

    checkout_page do
      expect(current_page.location).to match('example.com/checkout.html')
      expect(current_page.main_heading.text).to eq('Checkout')
      fill_form(
        card_number: '41111111111111111',
        month: 'January',
        year: 2022,
        cvv: 123
      )
    end
  end
end
