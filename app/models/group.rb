class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :pairs
  has_many :ideas
  has_many :rules, -> { order(:id) }, dependent: :destroy

  # Invite links carry this token. 24 base58 characters is about 140 bits, so it can't be guessed.
  has_secure_token :invite_token, length: 24

  validates :name, presence: true

  def owner?(user)
    user == owner
  end

  def member?(user)
    user_groups.where(user:).any?
  end

  def join(user)
    user_groups.find_or_create_by!(user: user)
  end

  # Groups only take new members while they're getting ready: once names are drawn, invite links
  # stop working until the draw is reset (or cleared by removing someone)
  def open_to_new_members?
    pairs.none?
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

  # Undoes the draw, so the group takes new members again and names can be drawn afresh. Gift ideas,
  # members and rules stay.
  def reset_draw
    pairs.destroy_all
  end

  # Clears last time's draw and gift ideas so the group can start again this year. Members stay.
  def reset
    transaction do
      pairs.destroy_all
      ideas.destroy_all
    end
  end
end
