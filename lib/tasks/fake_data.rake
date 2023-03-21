namespace :db do

  namespace :fake do

    task people: :environment do
      Person.transaction do
        all_roles = Role.all.to_a

        40.times.map do
          Person.create!(
            full_name: FFaker::Name.name,
            email: FFaker::Internet.email,
            urls: (rand(4)*rand(4)).times.map { FFaker::Internet.http_url },
            role_offers: all_roles.sample(rand(4)).uniq.map { |role| RoleOffer.new(role: role) },
            updated_at: 1.year.ago
          )
        end
      end
    end

    task projects: :environment do
      Project.transaction do
        all_people = Person.all.to_a
        all_roles = Role.all.to_a
        all_tags = Tag.all.to_a
        22.times.map do
          Project.create!(
            name: FFaker::Lorem.words(rand(2) + 1).map(&:capitalize).join(['', ' '].sample),
            url: (FFaker::Internet.http_url if rand < 0.5),
            tagline: FFaker::Company.catch_phrase[0...50],
            tags: all_tags.sample(rand(1..4) * rand(1..4)).uniq,
            description: FFaker::Lorem.paragraphs(4).join("\n\n"),
            participants: all_people.sample(rand(1..3) * rand(1..3)).uniq,
            role_requests: all_roles.sample(rand(5)).map { |role| RoleRequest.new(role: role) },
            updated_at: 1.year.ago
          )
        end
      end
    end

    task locations: :environment do
      5.times do
        Location.create!(name: FFaker::Lorem.words(rand(2) + 1).map(&:capitalize).join(" "))
          .update!(detail: FFaker::Lorem.words(rand(4) + 2).join(" ").capitalize)
      end
    end

    task events: :environment do
      Event.transaction do
        locations = Location.all.to_a

        events = 10.times do
          dates = rand(1..5).times.map do
            start_time = Time.now + rand(2.days .. 12.months)
            EventDate.new(
              start_time: start_time,
              end_time: (start_time + rand(3).hours if rand(2) > 0),
              location: locations.sample)
          end
          Event.create!(
            title: FFaker::Lorem.words(4).join(" ").capitalize,
            description: FFaker::Lorem.paragraphs(4).join("\n\n"),
            dates: dates)
        end
      end
    end

    task all: [:people, :projects, :events]
  end

end
