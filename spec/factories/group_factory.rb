FactoryBot.define do
  factory :group do
    name { "Group Name" }

    transient do
      owner { build(:user) }
    end

    after(:build) do |group, evaluator|
      group.owner = evaluator.owner if group.owner.nil?

      group.users << group.owner unless group.owner.in?(group.users)
    end
  end
end
