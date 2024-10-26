class User < ApplicationRecord
  has_secure_password

  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :pairs
  has_many :ideas
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy

  validates :name, presence: true
  validates :login, presence: true, uniqueness: true

  def ideas_in_current_group
    ideas.where(group: Current.group)
  end
end
