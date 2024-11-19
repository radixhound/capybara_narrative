module CapybaraNarrative
  module CapybaraProxy
    def self.included(base)
      base.class_eval do
        delegate_missing_to :page
      end
    end

    def proxy(&block)
      proxying! { @page.within(self, &block) }
    end

    # This will allow this object to duck type as a capybara node
    # and it can get pushed onto the scope like #within
    def to_capybara_node
      self
    end

    def init_capybara_proxy
      @page = Capybara.current_session
      @proxying = false
    end

    protected

    # This is a delicate balance. We add self to the scope, but
    # we'll get an infinite loop because current_session -> self -> current_session
    # so we have to short-circuit the process by doing the same thing as the
    # internals of Capybara::Session which will use @page.document if there is
    # nothing pushed to the scope
    def page
      @proxying ? @page.document : @page
    end

    def current_url
      @page.driver.current_url
    end

    def proxying!
      @proxying = true
      yield
      @proxying = false
    end

    def xpath(locator, options = {})
      find :xpath, locator, **options
    end

    def css(locator, options = {})
      find :css, locator, **options
    end

    def browser_action
      driver.browser.action
    end
  end
end
