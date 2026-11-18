class ApplicationMailer < ActionMailer::Base
  # Production must set MAILER_FROM to an address on a Resend-verified domain.
  default from: ENV.fetch("MAILER_FROM", "Secret Santa <santa@example.com>")
  layout "mailer"
end
