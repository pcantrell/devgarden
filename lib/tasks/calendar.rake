calendar_url = Rails.application.config.x.dev_garden.ics_url

namespace :calendar do

  task import: :environment do

    logger.info "Downloading calendar..."

    cal = Icalendar::Calendar.parse(URI.parse(calendar_url).read)

    logger.info "Parsing events..."

    window_start = Time.now.at_midnight
    window_end = window_start + 3.months

    problems = []

    Event.transaction(isolation: :serializable) do
      EventDate.where('start_time > ?', window_start).destroy_all

      cal.first.events.each do |cal_event|
        begin
          logger.info "Importing dates for #{cal_event.summary}"

          event = find_event(cal_event.summary)
          location = find_location(cal_event.location)

          if event.location != location
            problems <<
              "Warning: #{cal_event.summary} on #{cal_event.start_time} has a mismatched location: " +
              "#{event.location.name} != #{location.name}"
          end

          cal_event.occurrences_between(window_start, window_end).each do |occurrence|
            event.dates.create!(
              start_time: occurrence.start_time,
              end_time:   occurrence.end_time)
          end
        rescue => e
          logger.error e
          problems << e
        end
      end
    end

    logger.info "Calendar imported. Problems: #{problems.size}"

    unless problems.empty?
      AdminNotifications
        .calendar_import_had_problems(problems.map(&:to_s))
        .deliver_later
    end

    logger.info "Calendar import done"
  end

  def find_event(title)
    Event.find_by!(
      'lower(title) in (?, ?)',
      title.downcase,
      title.downcase
        .gsub(/^dev garden\s+/, '')
        .gsub(/(.*) - (.*)/, '\1'))
  rescue => e
    raise "No event #{title.inspect} (#{e.class}: #{e})"
  end

  def find_location(name)
    return nil if name.blank?

    Location.find_by!(
      'lower(name) = ?',
      name.gsub(/\s*\(.*\)\s*$/, '').downcase)
  rescue => e
    raise "No location #{title.inspect} (#{e.class}: #{e})"
  end

  def logger
    Rails.logger
  end

end
