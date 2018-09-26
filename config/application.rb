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

    config.active_job.queue_adapter = :que
    config.active_record.schema_format = :sql  # for que: https://github.com/chanks/que#usage

    config.cache_store = :dalli_store, 'localhost', {
      namespace: 'devgarden',
      expires_in: 1.hour,
      race_condition_ttl: 1.second,
      compress: true
    }

    config.x.dev_garden.ics_url = 'https://calendar.google.com/calendar/ical/macalester.edu_foee38ec77nqatr9hor7id17bk%40group.calendar.google.com/public/basic.ics'
    config.x.dev_garden.gcal_url = 'https://calendar.google.com/calendar?cid=bWFjYWxlc3Rlci5lZHVfZm9lZTM4ZWM3N25xYXRyOWhvcjdpZDE3YmtAZ3JvdXAuY2FsZW5kYXIuZ29vZ2xlLmNvbQ'
  end
end
