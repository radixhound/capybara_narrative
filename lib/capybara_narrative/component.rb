module CapybaraNarrative
  class Component
    include CapybaraProxy

    attr_reader :element

    delegate_missing_to :element

    def initialize(selector)
      init_capybara_proxy
      @element = selector.is_a?(String) ? page.find(selector) : selector
    end

    def within
      page.within element do
        yield
      end
    end
  end
end
