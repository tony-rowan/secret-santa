class Group < ApplicationRecord
  SECURE_ID_PURPOSE_INVITE_TOKEN = :invite_token

  belongs_to :owner, class_name: "User"
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :pairs

  before_validation :set_join_code
  validates :name, :join_code, presence: true

  def self.find_by_invite_token!(invite_token)
    find_signed!(invite_token, purpose: SECURE_ID_PURPOSE_INVITE_TOKEN)
  end

  def self.find_by_invite_token(invite_token)
    find_signed(invite_token, purpose: SECURE_ID_PURPOSE_INVITE_TOKEN)
  end

  def invite_token
    signed_id(purpose: SECURE_ID_PURPOSE_INVITE_TOKEN)
  end

  def owner?(user)
    user == owner
  end

  def join(user)
    user_groups.find_or_create_by!(user: user)
  end

  def kick(user)
    pairs.destroy_all
    user_groups.find_by(user: user).destroy
  end

  def assign_partners
    return unless users.count > 2

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

  def set_join_code
    return if join_code

    self.join_code = SecureRandom.hex(6).upcase
  end
end
