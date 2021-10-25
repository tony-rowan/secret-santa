class User < ApplicationRecord
  has_secure_password

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :pairs
  has_many :ideas

  def self.new_user_for_invite(name)
    User.new(
      name: name,
      login: name.downcase.gsub(/\W/, ''),
      password: SecureRandom.hex,
      invite_token: SecureRandom.hex
    )
  end

  def ideas_in_current_group
    ideas.where(group: Current.group)
  end
end
