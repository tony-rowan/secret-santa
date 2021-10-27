class User < ApplicationRecord
  has_secure_password

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :pairs
  has_many :ideas
  has_many :owned_groups, class_name: "Group"

  def self.new_user_for_invite(name)
    User.new(
      name: name,
      login: name.downcase.gsub(/\W/, ""),
      password: SecureRandom.hex,
      invite_token: SecureRandom.hex
    )
  end

  def groups_attributes=(groups_attributes)
    groups_attributes.values.each do |group_attributes|
      group = Group.new(group_attributes)
      group.owner = self
      groups << group
    end
  end

  def ideas_in_current_group
    ideas.where(group: Current.group)
  end
end
