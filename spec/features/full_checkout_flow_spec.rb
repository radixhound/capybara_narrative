require 'spec_helper'

RSpec.describe 'Checkout Flow', type: :feature do
  it 'navigates from the homepage to checkout' do
    home_page.visit do
      expect(current_page.main_heading.text).to eq('Pandas Love Teapots')
      fill_form(search: 'Flowers')
      click_on :submit_button
    end

    search_results_page do
      expect(this).to be_current_page
      expect(this.result_titles).to include('Pink Petunia Panda', 'Red Rose Panda')
    end
  end
end
