class User < ApplicationRecord
  has_many :user_groups
  has_many :groups, through: :user_groups
  has_many :pairs
  has_many :ideas
  has_many :owned_groups, class_name: "Group", foreign_key: "owner_id", dependent: :destroy

  # New accounts have no name until the person picks one after their first sign-in
  validates :name, presence: true, allow_nil: true
  normalizes :email, :unconfirmed_email, with: ->(email) { email.strip.downcase }

  validates :email, presence: true, uniqueness: true, format: {with: URI::MailTo::EMAIL_REGEXP, allow_blank: true}
  validates :unconfirmed_email, format: {with: URI::MailTo::EMAIL_REGEXP, allow_blank: true}
  validate :unconfirmed_email_not_taken

  generates_token_for :sign_in, expires_in: 15.minutes do
    last_signed_in_at
  end

  # Tied to the pending address, so changing or clearing it invalidates any link already sent
  generates_token_for :email_change, expires_in: 1.hour do
    unconfirmed_email
  end

  # Someone without an account signs up through the same emailed link as everyone else. Until they
  # follow it there's no record, so the link carries their email, signed, instead of a record token.
  def self.sign_up_token_verifier
    Rails.application.message_verifier(:sign_up)
  end

  def self.generate_sign_up_token(email)
    sign_up_token_verifier.generate(email, purpose: :sign_up, expires_in: 15.minutes)
  end

  # A new, unsaved user for the email in the token. Nil once that email has an account, which makes
  # the link single-use like a sign-in link.
  def self.build_from_sign_up_token(token)
    email = sign_up_token_verifier.verified(token, purpose: :sign_up)
    return if email.blank? || exists?(email:)

    new(email:)
  end

  def record_sign_in
    touch(:last_signed_in_at)
  end

  def ideas_in_current_group
    ideas.where(group: Current.group)
  end

  # Applies the pending address. Returns false (and drops the pending change) if someone else has
  # taken it since it was requested.
  def confirm_email_change
    return false if unconfirmed_email.blank?

    update!(email: unconfirmed_email, unconfirmed_email: nil)
    true
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
    restore_attributes
    update_column(:unconfirmed_email, nil)
    false
  end

  def cancel_email_change
    update!(unconfirmed_email: nil)
  end

  private

  def unconfirmed_email_not_taken
    return if unconfirmed_email.blank?
    return unless User.where.not(id:).exists?(email: unconfirmed_email)

    errors.add(:unconfirmed_email, :taken)
  end
end
