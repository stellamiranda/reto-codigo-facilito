FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "password" }
    authentication_token { SecureRandom.uuid }
  end
end
