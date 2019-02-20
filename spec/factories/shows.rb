FactoryBot.define do
  factory :show do
    title { Faker::Lorem.word }
    rss_url { "http://#{Faker::Games::Heroes.name}.com" }
    # association :user, factory: :user
  end
end
