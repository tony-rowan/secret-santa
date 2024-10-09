FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    sequence(:login) { |n| "#{FFaker::Internet.user_name}_#{n}" }
    password { "password" }

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
