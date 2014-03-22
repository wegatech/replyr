module Replyr
  class ReplyEmail
    attr_accessor :to, :from, :subject, :body, :files
  
    def initialize(mail)
      self.to = mail.to.first
      self.from = mail.from.first
      self.subject = mail.subject
      self.body = mail.multipart? ? mail.text_part.decoded : mail.decoded

      # Extract Attachments and store as StringIO in files
      # can later be processed by e.g. carrierwave
      #
      self.files = mail.attachments.map do |attachment|
        file = StringIO.new(attachment.decoded)
        file.class.class_eval { attr_accessor :original_filename, :content_type }
        file.original_filename = attachment.filename
        file.content_type = attachment.mime_type
        file
      end
    end
    
    def self.process(mail)
      reply_mail = new(mail)
      reply_mail.process
    end

    # Checks if this incoming mail is a reply email
    #
    def is_reply_email?
      to.starts_with?(Replyr.config.prefix)
    end

    def stripped_body
      EmailReplyParser.parse_reply(body, from).to_s.force_encoding("UTF-8")
    end
  
    def process
      if is_reply_email?
        if reply_address = ReplyAddress.new_from_address(to)
          reply_address.model.class.handle_reply(reply_token, stripped_body, attached_files)
        else
          # no valid reply_address
        end
      end
    end
  
  end

end