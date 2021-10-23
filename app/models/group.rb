class Group < ApplicationRecord
  has_many :user_groups
  has_many :users, through: :user_groups

  def join(user)
    user_groups.find_or_create_by!(user: user)
  end

  def shuffle
    # /shrug
  end
end
