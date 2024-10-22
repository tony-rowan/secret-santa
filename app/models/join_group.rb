class JoinGroup
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :join_code, :string
  attribute :user

  validates :join_code, presence: true
  validates :user, presence: true
  validate :group_exists

  def group
    return @_group if defined?(@_group)

    @_group = Group.find_by(join_code:)
  end

  def save
    return false unless valid?

    user.groups << group

    true
  end

  private

  def group_exists
    return if join_code.blank? # Don't add not found error if there's nothing to find

    unless group.present?
      errors.add(:join_code, "Code not recognised, please check it over and try again")
    end
  end
end
