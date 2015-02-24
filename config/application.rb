require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(*Rails.groups)

module DevGarden
  class Application < Rails::Application
    config.time_zone = 'Central Time (US & Canada)'

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators.stylesheets = false
    config.generators.javascripts = false
    config.generators.helper      = false
    config.generators.test        = false
  end
end
