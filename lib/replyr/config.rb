module Replyr
  class Config
    attr_accessor :prefix, :host, :secret, :user_class
    
    def prefix
      @prefix || "reply"
    end
    
    def user_class
      @user_class || User
    end
    
    def host
      @host || (raise RuntimeError, "Replyr.config.host is nil. Please set a host in an initializer.")
    end
    
    def secret
      @secret || (raise RuntimeError, "Replyr.config.secret is nil. Please set a secure secret token in an initializer.")
    end
    
  end
end