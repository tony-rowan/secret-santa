class UpdateAccount
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  attribute :user
  attribute :name
  attribute :email

  # The name is saved straight away; a different email is only held as `unconfirmed_email` until the
  # link sent to the new address is followed. The account page sends the two separately, so a field
  # that wasn't submitted (nil) is left alone.
  def perform
    user.name = name unless name.nil?
    user.unconfirmed_email = new_email if email_changing?

    if user.save
      deliver_confirmation if email_changing?
      true
    else
      move_email_errors
      user.restore_attributes([:unconfirmed_email])
      false
    end
  end

  def email_changing?
    new_email.present? && new_email != user.email
  end

  private

  def new_email
    @_new_email ||= User.normalize_value_for(:email, email.to_s)
  end

  def deliver_confirmation
    UserMailer.confirm_email_change(user).deliver_later
  end

  # The form has no unconfirmed email field, so show those errors against the email field
  def move_email_errors
    Array(user.errors.delete(:unconfirmed_email)).each do |message|
      user.errors.add(:email, message)
    end
  end
end
