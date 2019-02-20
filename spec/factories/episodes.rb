FactoryBot.define do
  factory :episode do
    title { Faker:: Lorem.word }
    association show, factory: :show
  end
end
