namespace :db do

  desc "Fill DB with fake data"
  task fake: :environment do
    Person.transaction do
      all_roles = Role.all.to_a
      all_tags = Tag.all.to_a

      people = 40.times.map do
        Person.create!(
          name: FFaker::Name.name,
          email: (FFaker::Internet.email if rand < 0.4),
          url: (FFaker::Internet.http_url if rand < 0.1),
          role_offers: all_roles.sample(rand(4)).uniq.map { |role| RoleOffer.new(role: role) },
          updated_at: 1.year.ago
        )
      end

      projects = 22.times.map do
        Project.create!(
          name: FFaker::Lorem.words(rand(2) + 1).map(&:capitalize).join(['', ' '].sample),
          url: (FFaker::Internet.http_url if rand < 0.5),
          tagline: FFaker::Company.catch_phrase,
          tags: all_tags.sample(rand(1..4) * rand(1..4)).uniq,
          description: FFaker::Lorem.paragraphs(4).join("\n\n"),
          participants: people.sample(rand(1..3) * rand(1..3)).uniq,
          role_requests: all_roles.sample(rand(5)).map { |role| RoleRequest.new(role: role) },
          updated_at: 1.year.ago
        )
      end

      locations = Location.all.to_a

      events = 10.times do
        dates = rand(1..5).times.map do
          start_time = Time.now + rand(1.second .. 4.months)
          EventDate.new(
            start_time: start_time,
            end_time: (start_time + rand(3).hours if rand(2) > 0))
        end
        Event.create!(
          title: FFaker::Lorem.words(4).join(" ").capitalize,
          description: FFaker::Lorem.paragraphs(4).join("\n\n"),
          location: locations.sample,
          dates: dates)
      end
    end
  end

end
