require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Whattodo
  class Application < Rails::Application
    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller

    I18n.config.enforce_available_locales = true

    config.generators do |g|
        g.test_framework :rspec, :fixture => false
        g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end

    config.time_zone
    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper = false
    config.generators.specs = false

    config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.watchable_dirs['lib'] = [:rb]
  end
end
