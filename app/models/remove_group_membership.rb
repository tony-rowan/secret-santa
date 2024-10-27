class RemoveGroupMembership
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attr_reader :messages

  attribute :group
  attribute :member
  attribute :actor

  validate :member_is_part_of_group

  def initialize(...)
    super

    @messages = {
      success: [],
      notice: []
    }
  end

  def perform
    return false unless valid?

    group.transaction do
      removed_pairs = group.pairs.destroy_all
      group.user_groups.where(user: member).destroy_all

      if actor == member
        add_success_message("Left group #{group.name}!")
      else
        add_success_message("Removed #{member.name} from the group!")
      end

      if actor != member && removed_pairs.any?
        add_notice_message("Secret santa partners have been un-assigned")
      end
    end

    true
  end

  private

  def member_is_part_of_group
    return if group.member?(member)

    errors.add(:base, "That user isn't a member of the group")
  end

  def add_success_message(message)
    messages[:success] << message
  end

  def add_notice_message(message)
    messages[:notice] << message
  end
end
