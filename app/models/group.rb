class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :pairs
  has_many :ideas
  has_many :rules, -> { order(:id) }, dependent: :destroy

  before_validation :set_join_code
  validates :name, :join_code, presence: true

  def owner?(user)
    user == owner
  end

  def member?(user)
    user_groups.where(user:).any?
  end

  def join(user)
    user_groups.find_or_create_by!(user: user)
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

  # Clears last time's draw and gift ideas so the group can start again this year. Members stay.
  def reset
    transaction do
      pairs.destroy_all
      ideas.destroy_all
    end
  end

  private

  def set_join_code
    return if join_code

    self.join_code = SecureRandom.hex(6).upcase
  end
end
