FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    sequence(:login) { |n| "#{FFaker::Internet.user_name}_#{n}" }
    password { "password" }
  end
end
