# Deletes a user and everything of theirs. Groups they organise are deleted for everyone (there's no
# one to hand them to); in other groups they're removed like a member who leaves, which un-draws names.
class DeleteAccount
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :user

  def perform
    user.transaction do
      user.owned_groups.each { |group| delete_group(group) }
      user.groups.each { |group| leave_group(group) }
      user.ideas.destroy_all
      user.destroy!
    end

    true
  end

  private

  def delete_group(group)
    group.pairs.destroy_all
    group.ideas.destroy_all
    group.rules.destroy_all
    group.user_groups.destroy_all
    group.destroy!
  end

  def leave_group(group)
    group.pairs.destroy_all
    group.user_groups.where(user:).destroy_all
  end
end
