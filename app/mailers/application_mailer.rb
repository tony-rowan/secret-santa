class ApplicationMailer < ActionMailer::Base
  # Production sets MAILER_FROM to an address the SMTP server is allowed to send from.
  default from: ENV.fetch("MAILER_FROM", "Secret Santa <santa@example.com>")
  layout "mailer"
end
