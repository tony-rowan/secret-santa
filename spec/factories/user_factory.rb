FactoryBot.define do
  factory :user do
    name { FFaker::Name.name }
    login { FFaker::Internet.user_name }
    password { "password" }
  end
end
