require File.expand_path('../boot', __FILE__)

require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require(*Rails.groups)

module DevGarden
  class Application < Rails::Application
    config.time_zone = 'Central Time (US & Canada)'

    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper      = false
  end
end
