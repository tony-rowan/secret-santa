# Action Mailer observer (development only) that prints each delivered email
# decoded, so links aren't mangled by quoted-printable encoding.
class DevelopmentMailLogger
  DIVIDER = "=" * 72

  def self.delivered_email(message)
    Rails.logger.info(format_message(message))
  end

  def self.format_message(message)
    [
      DIVIDER,
      "To: #{Array(message.to).join(", ")}",
      "Subject: #{message.subject}",
      "",
      readable_body(message),
      DIVIDER
    ].join("\n")
  end

  def self.readable_body(message)
    part = message.text_part || message
    part.decoded.to_s.gsub("\r\n", "\n").strip
  end
end
