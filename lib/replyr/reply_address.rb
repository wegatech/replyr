module Replyr
  class ReplyAddress
    attr_accessor :model, :user
    
    # Create a new reply address from a given user and model
    #
    def initialize(model, user)
      @model = model
      @user = user
    end
    
    # Create a reply address from a given address string
    # Checks for validity of address and raises an ArgumentError
    # if it's invalid.
    #
    def self.new_from_address(address)
      parts = get_parsed_address(address)

      model_class = class_from_normalized_model_name(parts[:model_name])
      model = model_class.find(parts[:model_id])
      user = Replyr.config.user_class.find(parts[:user_id])

      address = new(model, user)
      if address.token_valid?(parts[:token])
        address
      else
        Replyr.logger.warn "Reply email address invalid."
        nil
      end
    end
    
    # Check if a given token is valid
    #
    def token_valid?(token)
      token == self.token
    end
    
    # Split the reply email address. It has the following format:
    # reply-comment-12-56-01ce26dc69094af9246ea7e7ce9970aff2b81cc9@reply.example.com
    #
    def self.get_parsed_address(address)
      parsed = Mailman::Route::StringMatcher.new(Replyr.address_pattern).match(address)

      if parsed.nil?
        raise ArgumentError, "Malformed reply email address."
      else
        parsed.first # return Hash part
      end
    end
    
    # Returs the token from this address
    #
    def token
      token_from_user_and_model(@user, @model)
    end
    
    # Creates a token from the passed user and model objects
    # Uses the configured secret as a salt
    #
    def token_from_user_and_model(user, model)
      user_id = id_from_model(user)
      model_id = id_from_model(model)
      model_name = normalized_model_name(model)

      Digest::SHA1.hexdigest("#{user_id}-#{model_name}-#{model_id}-#{Replyr.config.secret}")
    end
    
    # Model name by be namespaced (e.g. MyApp::Comment)
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

    # Returns the address string
    # (e.g reply-comment-12-56-01ce26dc69094af9246ea7e7ce9970aff2b81cc9@reply.example.com)
    #
    def address
      user_id = id_from_model(@user)
      model_id = id_from_model(@model)
      model_name = normalized_model_name(@model)

      local_part = [Replyr.config.prefix, model_name, model_id, user_id, token].join("-")
      "#{local_part}@#{Replyr.config.host}"
    end
    alias_method :to_s, :address

  end
end