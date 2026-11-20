class LegalPagesController < ApplicationController
  layout "document"

  def privacy
    render locals: {contact_email:}
  end

  def terms
    render locals: {contact_email:}
  end

  private

  def contact_email
    Rails.configuration.x.contact_email
  end
end
