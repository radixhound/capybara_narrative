require "capybara_narrative/version"
require 'active_support/descendants_tracker'
require 'active_support/core_ext'
require 'active_support/core_ext/string'

require_relative 'capybara_narrative/labels'
require_relative 'capybara_narrative/capybara_proxy'
require_relative 'capybara_narrative/page'
require_relative 'capybara_narrative/component'

module CapybaraNarrative
  class Error < StandardError; end
  class InvalidClassName < NameError; end

  CapybaraNarrative::Page::ADDITIONAL_METHODS.each do |method|
    # Adds the method like Capaybara::DSL does
    define_method method do |*args, &block|
      page.send method, *args, &block
    end

    # Adds the method to Capybara::Session which is called
    # by the DSL method
    Capybara::Session.class_eval do
      define_method method do |*args, &block|
        @touched = true
        current_scope.send(method, *args, &block)
      end
    end
  end

  def self.snakecase(string)
    string.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr('-', '_').
      gsub(/\s/, '_').
      gsub(/__+/, '_').
      downcase
  end

  # When CapybaraNarrative gets included, go searching for all page
  # objects and make an accessor method for them.
  #
  # For the page object HomePage this will create a method home_page
  # that returns an instance of the page object and also allows for
  # the block syntax to be supported:
  #
  #  home_page do
  #    fill_form(first_name: 'Naruto')
  #  end
  def self.included(base)
    base.class_eval do
      CapybaraNarrative::Page.descendants.each do |klass|
        method_name = CapybaraNarrative.snakecase(klass.to_s.match(/\w*$/)[0])
        unless method_name.ends_with?('_page')
          raise InvalidClassName, "#{klass}: Page objects must have the Page keyword in it e.g. HomePage"
        end

        define_method(method_name) do |&block|
          page_object = if instance_variables.include?("@#{method_name}".to_sym)
                          instance_variable_get("@#{method_name}")
                        else
                          instance_variable_set("@#{method_name}", klass.new)
                        end
          return page_object.proxy(&block) if block

          page_object
        end
      end
    end
  end
end
