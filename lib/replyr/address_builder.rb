require 'openssl'

module Replyr
  module AddressBuilder
    # Model name may be namespaced (e.g. MyApp::Comment)
    # For the reply email address the model name will be converted to "my_app/comment".
    # Then the slash "/" will be replaced with a plus sign "+", because
    # slashes should not be used email addresses.
    #
    def normalized_model_name(model)
      model.class.name.tableize.singularize.gsub("/", "+")
    end
    
    # Converts a normalized model_name back to a real model name
    # and returns the class
    #
    def self.class_from_normalized_model_name(model_name)
      model_name.gsub("+", "/").classify.constantize
    end
    
    # Returns the ID of an AR object.
    # Uses primary key to find out the correct field
    #
    def id_from_model(object)
      object.send(object.class.primary_key)
    end
    
    # Split the reply/bounce email address. It has the following format:
    # Reply: reply-comment-12-56-01ce26dc69094af9246ea7e7ce9970aff2b81cc9@reply.example.com
    # Bounce: bounce-newsletter-12-01ce26dc69094af9246ea7e7ce9970aff2b81cc9@bounce.example.com
    #
    def self.get_parsed_address(address)
      if match_data = Replyr.route.match(address)
        match_data
      else
        raise ArgumentError, "Malformed reply/bounce email address."
      end
    end
    
    # Creates a token from the passed model (and user if passed) 
    # Uses the configured secret as a salt
    #
    def create_token(model, user = nil)
      user_id = user.present? ? id_from_model(user) : nil
      model_id = id_from_model(model)
      model_name = normalized_model_name(model)

      OpenSSL::HMAC.hexdigest(
        OpenSSL::Digest.new('sha1'),
        Replyr.config.secret,
        [user_id, model_name, model_id].compact.join("-")
      )
    end
        
    # Check if a given token is valid
    #
    def token_valid?(token)
      token == self.token
    end
    
    # Ensure a given token is valid
    #
    def ensure_valid_token!(token)
      raise(RuntimeError, "Token invalid.") unless token_valid?(token)
    end
    
    
  end
end