# Joining a group from its invite link. Only works while the group is open to new members (names
# not drawn); people already in the group can follow the link again whenever they like.
class JoinGroup
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :invite_token, :string
  attribute :user

  validates :user, presence: true
  validate :group_takes_user

  def group
    return @_group if defined?(@_group)

    @_group = (Group.find_by(invite_token:) if invite_token.present?)
  end

  def already_member?
    group.present? && group.member?(user)
  end

  # The link is right but the group isn't taking anyone new
  def closed?
    group.present? && !already_member? && !group.open_to_new_members?
  end

  def save
    return false unless valid?

    group.join(user)

    true
  end

  private

  def group_takes_user
    if group.nil?
      errors.add(:invite_token, :unknown)
    elsif closed?
      errors.add(:invite_token, :closed)
    end
  end
end
