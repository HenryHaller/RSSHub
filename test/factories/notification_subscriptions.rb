FactoryBot.define do
  factory :notification_subscription do
    user { nil }
    show { nil }
    subscribed { false }
  end
end
