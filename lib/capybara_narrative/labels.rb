module CapybaraNarrative
  module Labels
    def with_page_url(url)
      @page_url = url.freeze
    end

    def page_url
      @page_url
    end

    # The purpose of mapping labels is to provide a solid concept that
    # will not change regardless of the underlying text on the link or button.
    # So if the text changes the only place that needs to be updated is the
    # page object, not all the tests that refer to that button or link.
    def map_label(name, locator)
      @labels ||= {}
      @labels[name] = locator
    end

    # The purpose of defining form labels is similar to defining labels.
    # The elements of the form are mapped to a symbol that represents the
    # thing to be filled in. Then if the name or identifier for the thing
    # changes, the only thing to be updated is the page object and the tests
    # still work.
    def form_label(name, options = {})
      form_labels[name] = LabelOptions.new(options)
    end

    def form_labels
      @form_labels ||= {}
    end

    def labels
      @labels || {}
    end

    def elements
      @elements || {}
    end

    def element(name)
      elements[name] = true # FIXME: Maybe need a better implementation?
    end

    # Labels::LabelOptions
    #
    # This class is responsible for storing the options passed in
    # to the label definition. Primarily it handles picking the
    # method to use for interacting with the form object.
    # Sometimes the form object isn't simple and we need to provide
    # a method to call to handle the interaction.
    class LabelOptions
      attr_reader :label, :method
      def initialize(options = {})
        raise 'Provide either :label or :method' if options.keys - [:label, :method] == options.keys.length
        @label = options.fetch(:label, nil)
        @method = options.fetch(:method, nil)
      end

      def label?
        @label.present?
      end
    end
  end
end
