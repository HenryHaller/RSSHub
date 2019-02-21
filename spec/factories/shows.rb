FactoryBot.define do
  factory :show do
    title { Faker::Lorem.word }
    rss_url { "http://#{Faker::Alphanumeric.alpha 10}.com" }
    association :users
  end
end
