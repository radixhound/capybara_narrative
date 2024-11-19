
module CapybaraNarrative
  class Page
    ADDITIONAL_METHODS = %i{fill_form click_element current_page page_url}.freeze
    extend ActiveSupport::DescendantsTracker
    extend Labels
    include CapybaraProxy

    def initialize
      init_capybara_proxy
    end

    def page_url(params = {})
      raise 'page_url must be defined for a page object' unless self.class.page_url

      # TODO: I (Ian S.) added this to support ud_ui_checkout_test and am
      # certain there's a plan to do this in a less quick-n-dirty way. Let's
      # make sure this gets cleaned up properly
      url = self.class.page_url.dup

      params.keys.each do |key|
        next unless url.match? ":#{key}"

        url.gsub!(":#{key}", params.delete(key).to_s)
      end

      [url, params.to_param.presence].compact.join('?')
    end

    def current_page
      self
    end

    # visit
    #
    # like Capybara's visit except it's locked to the url of this page
    # and it also allows a block syntax like #within so that all calls
    # inside of it will get proxied to the page
    def visit(params = {}, &block)
      page.visit(page_url(params))
      proxy(&block) if block_given?
    end

    # fill_form
    #
    # Takes in a hash of form values and sends them to the right form fields
    # this takes advantage of the form_labels defined for this page object
    # to be able to call a method to do the form filling for more complex
    # interactions.
    #
    # Example:
    #   class SomePage
    #      form_label :search, label: 'Search'
    #      form_label :start_date, method: :pick_date
    #   end
    #
    #   some_page.fill_form(
    #     search: 'San Francisco',
    #     start_date: 2.days.from_now
    #   )
    #
    def fill_form(form_data = {})
      form_data.each do |label, value|
        label_options = self.class.form_labels[label] || raise("Undefined form_label '#{label}' for #{self.class.name}.")
        if label_options.label?
          fill_in(label_options.label, with: value) && next
        else
          send(label_options.method, value)
        end
      end
    end

    # click_on
    #
    # like Capybara's click_on except it will look up a label in the
    # page labels instead of using a string
    def click_on(*args, context: page)
      label = self.class.labels[args[0]] # attempt to get the label
      context = context.element if context.respond_to? :element
      label.present? ? context.click_on(label) : context.click_on(*args)
    end

    # click_element
    #
    # Click an element with some attributes, pass in the attributes
    def click_element(element_label, options = {})
      if options.empty?
        send(element_label).click
      else
        send(element_label, **options).click
      end
    end
  end
end
