# frozen_string_literal: true

require 'capybara_narrative/version'
require 'active_support/descendants_tracker'
require 'active_support/core_ext/object'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/module/delegation'

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

  def self.create_page_accessor(method_name, klass)
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

  def self.snakecase(string)
    string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
          .gsub(/([a-z\d])([A-Z])/, '\1_\2')
          .tr('-', '_')
          .gsub(/\s/, '_')
          .gsub(/__+/, '_')
          .downcase
  end

  # When AutoloadPageObjects gets included, it will search for all page
  # objects and make an accessor method for them.
  #
  # For the page object HomePage this will create a method home_page
  # that returns an instance of the page object and also allows for
  # the block syntax to be supported:
  #
  #  home_page do
  #    fill_form(first_name: 'Naruto')
  #  end
  module AutoloadPageObjects
    def self.included(base)
      base.class_eval do
        CapybaraNarrative::Page.descendants.each do |klass|
          method_name = CapybaraNarrative.snakecase(klass.to_s.match(/\w*$/)[0])
          unless method_name.ends_with?('_page')
            raise InvalidClassName, "#{klass}: Page object names must have the Page keyword e.g. HomePage"
          end

          CapybaraNarrative.create_page_accessor(method_name, klass)
        end
      end
    end
  end

  # Use ManualPageObjects if you want to explicitly load your pages in a
  # test run. For example:
  #
  #   RSpec.describe 'some feature', type: :feature do
  #     load_pages home_page: 'HomePage', search_results_page: 'SearchResultsPage'
  #
  module ManualPageObjects
    def self.included(base)
      base.extend(ClassMethods)
    end

    # These will be added as DSL methods onto the test class
    module ClassMethods
      def load_pages(pages = {})
        pages.each do |method_name, class_name|
          klass = CapybaraNarrative::Page.descendants.find { |descendant| descendant.to_s =~ /::#{class_name}/ }
          raise InvalidClassName, "#{class_name}: Can't find a descendant of Page with this name" unless klass

          CapybaraNarrative.create_page_accessor(method_name, klass)
        end
      end
    end
  end
end
