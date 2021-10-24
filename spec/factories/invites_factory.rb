FactoryBot.define do
  factory :invite do
    user { nil }
    group { nil }
    code { 'MyString' }
  end
end
