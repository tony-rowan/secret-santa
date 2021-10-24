class User < ApplicationRecord
  has_secure_password

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :pairs
  has_many :ideas

  def self.new_user_for_invite(name)
    User.new(
      name: name,
      password: SecureRandom.hex,
      invite_token: SecureRandom.hex
    )
  end
end
