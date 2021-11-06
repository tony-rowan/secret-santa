FactoryBot.define do
  factory :idea do
    idea { FFaker::Product.product }
    user
    group
  end
end
