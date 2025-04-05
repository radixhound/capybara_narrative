require 'rails/railtie'

module CapybaraNarrative
  class Railtie < Rails::Railtie
    # This ensures that our generators are loaded
    generators do
      require 'generators/capybara_narrative/install_generator'
    end
  end
end
