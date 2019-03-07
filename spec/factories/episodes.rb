FactoryBot.define do
  factory :episode do
    title { Time.now.to_a.shuffle.join }
    association :show
  end
end
