
module CapybaraNarrative
  class SearchResultsPage < Page
    with_page_url '/search_results.html'

    def current_page?
      current_url =~ /#{page_url}$/
    end

    def main_heading
      css('h1')
    end

    def result_titles
      find_all('.search-results--title').map(&:text)
    end

    private

    # use like `click_element :result_title, text: 'some thing'`
    def result_title(**options)
      css('.search-results--title a', options)
    end
  end
end