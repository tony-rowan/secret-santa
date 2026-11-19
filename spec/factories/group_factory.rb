FactoryBot.define do
  factory :group do
    name { FFaker::Company.name }

    transient do
      owner { build(:user) }
      rule_texts { [] }
    end

    after(:build) do |group, evaluator|
      group.owner = evaluator.owner if group.owner.nil?

      group.users << group.owner unless group.owner.in?(group.users)

      evaluator.rule_texts.each { |text| group.rules.build(text:) }
    end
  end
end
