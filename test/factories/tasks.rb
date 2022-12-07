FactoryBot.define do
  factory :task do
    title { Faker::Lorem.unique.words.join(" ") }
    description { Faker::Lorem.unique.words.join(" ") }
    user
  end
end
