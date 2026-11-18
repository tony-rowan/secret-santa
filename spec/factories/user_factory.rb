FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    sequence(:email) { |n| "user#{n}@example.com" }

    trait :with_group do
      transient {
        group_name { FFaker::Internet.user_name }
      }

      after(:build) do |user, evaluator|
        user.groups << build(:group, name: evaluator.group_name)
      end
    end
  end
end
