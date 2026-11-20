class Group < ApplicationRecord
  belongs_to :owner, class_name: "User"
  has_many :user_groups
  has_many :users, through: :user_groups
  has_many :pairs
  has_many :ideas
  has_many :rules, -> { order(:id) }, dependent: :destroy

  before_validation :set_join_code
  validates :name, :join_code, presence: true

  # Crockford's base32: digits and letters without I, L, O and U, so codes have no look-alikes.
  # 8 characters gives about a trillion codes. (Older groups have 12 hex characters, a subset.)
  JOIN_CODE_ALPHABET = "0123456789ABCDEFGHJKMNPQRSTVWXYZ".chars.freeze
  JOIN_CODE_LENGTH = 8

  # Typed codes are forgiving, as Crockford intended: case, spaces and hyphens don't matter, and
  # O, I and L read as 0, 1 and 1. Applies to finders too, so find_by(join_code: "abcd-ef12") works.
  normalizes :join_code, with: ->(code) { code.upcase.gsub(/[^0-9A-Z]/, "").tr("OIL", "011") }

  # The join code in groups of four for people to read and type, e.g. "ABCD-EF12"
  def formatted_join_code
    join_code.scan(/.{1,4}/).join("-")
  end

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

    self.join_code = loop do
      code = SecureRandom.alphanumeric(JOIN_CODE_LENGTH, chars: JOIN_CODE_ALPHABET)
      break code unless Group.exists?(join_code: code)
    end
  end
end
