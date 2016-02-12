namespace :db do

  desc "Fill DB with fake data"
  task fake: :environment do
    Person.transaction do
      all_roles = Role.all.to_a

      people = 40.times.map do
        Person.create!(
          name: FFaker::Name.name,
          email: (FFaker::Internet.email if rand < 0.4),
          url: (FFaker::Internet.http_url if rand < 0.1),
          role_offers: all_roles.sample(rand(4)).map { |role| RoleOffer.new(role: role) }
        )
      end

      projects = 12.times do
        Project.create!(
          name: FFaker::Lorem.words(rand(2) + 1).map(&:capitalize).join(['', ' '].sample),
          url: (FFaker::Internet.http_url if rand < 0.5),
          tagline: FFaker::Company.catch_phrase,
          participants: people.sample(1 + rand(3)),
          role_requests: all_roles.sample(rand(5)).map { |role| RoleRequest.new(role: role) }
        )
      end
    end
  end

end
