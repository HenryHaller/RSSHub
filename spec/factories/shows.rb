FactoryBot.define do
  factory :show do
    title { Faker::Lorem.word }
    rss_url { Faker::Games::Heroes.name }
    association :user, factory: :user
  end
end
