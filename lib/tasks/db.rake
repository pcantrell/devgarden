namespace :db do

  desc "Fill DB with fake data"
  task fake: :environment do
    Person.transaction do
      people = 40.times.map do
        Person.create!(
          name: Faker::Name.name,
          email: (Faker::Internet.email if rand < 0.4),
          url: (Faker::Internet.http_url if rand < 0.1)
        )
      end

      projects = 12.times do
        Project.create!(
          name: Faker::Lorem.words(rand(2) + 1).map(&:capitalize).join(['', ' '].sample),
          url: (Faker::Internet.http_url if rand < 0.5),
          description: Faker::Company.catch_phrase,
          participants: people.sample(1 + rand(3))
        )
      end
    end
  end

end
