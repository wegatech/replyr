module Replyr
  class ReplyAddress
    include AddressBuilder
    
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
      parts = AddressBuilder.get_parsed_address(address)

      model_class = AddressBuilder.class_from_normalized_model_name(parts[:model_name])
      model = model_class.find(parts[:model_id])
      user = Replyr.config.user_class.find(parts[:user_id])

      address = new(model, user)
      address.ensure_valid_token!(parts[:token])
      address
    rescue
      Replyr.logger.warn "Reply email address invalid."
      nil
    end
    
    # Returs the token from this address
    #
    def token
      create_token(@model, @user)
    end
    
    # Returns the address string
    # (e.g reply-comment-12-56-01ce26dc69094af9246ea7e7ce9970aff2b81cc9@reply.example.com)
    #
    def address
      user_id = id_from_model(@user)
      model_id = id_from_model(@model)
      model_name = normalized_model_name(@model)

      local_part = [Replyr.config.reply_prefix, model_name, model_id, user_id, token].join("-")
      "#{local_part}@#{Replyr.config.reply_host}"
    end
    alias_method :to_s, :address

  end
end