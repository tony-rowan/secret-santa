FactoryBot.define do
  factory :pair do
    group
    user
    association(:other, factory: :user)
  end
end
