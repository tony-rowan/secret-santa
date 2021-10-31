class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :pairs

  before_create :set_invite_token

  validates :name, presence: true

  def join(user)
    user_groups.find_or_create_by!(user: user)
  end

  def shuffle
    pairs.destroy_all

    ids = users.pluck(:id)
    valid = false
    pairings = []
    until valid
      pairings = ids.zip(ids.shuffle)
      valid = pairings.all? { |p| p[0] != p[1] }
    end

    pairings.each { |p| pairs.create!(user_id: p[0], other_id: p[1]) }
  end

  private

  def set_invite_token
    self.invite_token = invite_token || SecureRandom.hex(3).upcase
  end
end
