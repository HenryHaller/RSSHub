FactoryBot.define do
  factory :show do
    title { Faker::Lorem.word }
    rss_url { "http://localhost:3001/items.rss" }
    association :users
  end
end
