require "base_mailer/engine"

require "base_mailer/engine"
require "ostruct"

module BaseMailer
  def self.deliver(mail_template, recipient_email, data)
    seperator_index = mail_template.rindex("/")
    mailer_class    = mail_template[0...seperator_index]
    template        = mail_template[seperator_index+1..-1]

    mailer = "::BaseMailer::#{mailer_class.camelize}Mailer".constantize

    mailer.send(template, recipient_email, OpenStruct.new(data)).deliver_now
  rescue Net::SMTPFatalError, Net::SMTPServerBusy
    # do nothing, possible errors:
    #
    # Net::SMTPFatalError: 550 5.1.1 <unknown-address@example.com>:
    # Recipient address rejected: User unknown in virtual mailbox table
    # Net::SMTPServerBusy: 421 invalid sender domain (misconfigured dns?):
    # Sent by some mail providers when the domain is not found on their server
  end
end
