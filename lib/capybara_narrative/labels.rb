module CapybaraNarrative
  module Labels
    def with_page_url(url)
      @page_url = url.freeze
    end

    def page_url
      @page_url
    end

    def form_label(name, options = {})
      form_labels[name] = LabelOptions.new(options)
    end

    def map_label(name, locator)
      @labels ||= {}
      @labels[name] = locator
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
