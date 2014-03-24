module Replyr
  class Config
    attr_accessor :reply_prefix, 
                  :reply_host, 
                  :bounce_prefix,
                  :bounce_host,
                  :secret, 
                  :user_class
    
    def reply_prefix
      @reply_prefix || "reply"
    end

    def bounce_prefix
      @bounce_prefix || "bounce"
    end
    
    def user_class
      @user_class || User
    end
    
    def reply_host
      @reply_host || (raise RuntimeError, "Replyr.config.reply_host is nil. Please set a host in an initializer.")
    end

    def bounce_host
      @bounce_host || (raise RuntimeError, "Replyr.config.bounce_host is nil. Please set a host in an initializer.")
    end
    
    def secret
      @secret || (raise RuntimeError, "Replyr.config.secret is nil. Please set a secure secret token in an initializer.")
    end
    
  end
end