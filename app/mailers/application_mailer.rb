class ApplicationMailer < ActionMailer::Base
  # The address must be on a domain verified with the SMTP provider (Resend); MAILER_FROM overrides it.
  default from: ENV.fetch("MAILER_FROM", "Secret Santa by muddle <santa@updates.secretsanta.getmuddle.app>")
  layout "mailer"
end
