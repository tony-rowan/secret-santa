class RemoveGroupMembership
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :group
  attribute :member
  attribute :actor

  validate :member_is_part_of_group

  def perform
    return false unless valid?

    group.transaction do
      group.pairs.destroy_all
      group.user_groups.where(user: member).destroy_all
      group.ideas.where(user: member).destroy_all
    end

    true
  end

  private

  def member_is_part_of_group
    return if group.member?(member)

    errors.add(:base, "That user isn't a member of the group")
  end
end
