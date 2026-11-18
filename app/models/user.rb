class User < ApplicationRecord
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :pairs
  has_many :ideas
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy

  validates :name, presence: true
  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP, allow_blank: true}

  generates_token_for :sign_in, expires_in: 15.minutes do
    last_signed_in_at
  end

  def record_sign_in
    touch(:last_signed_in_at)
  end

  def ideas_in_current_group
    ideas.where(group: Current.group)
  end
end
