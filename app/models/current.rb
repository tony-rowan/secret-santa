class Current < ActiveSupport::CurrentAttributes
  attribute :user, :group

  def user=(user)
    super
    Current.group = user.groups.last
  end
end
