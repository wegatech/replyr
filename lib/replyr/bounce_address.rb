require 'openssl'

module Replyr
  class BounceAddress
    include AddressBuilder
    
    attr_accessor :model
    
    # Create a new reply address from a given user and model
    #
    def initialize(model)
      @model = model
    end
    
    # Create a reply address from a given address string
    # Checks for validity of address and raises an ArgumentError
    # if it's invalid.
    #
    def self.new_from_address(address)
      parts = AddressBuilder.get_parsed_address(address)

      model_class = AddressBuilder.class_from_normalized_model_name(parts[:model_name])
      model = model_class.find(parts[:model_id])

      address = new(model)
      address.ensure_valid_token!(parts[:token])
      address
    rescue
      Replyr.logger.warn "Bounce email address invalid."
      nil
    end
    
    # Returs the token from this address
    #
    def token
      create_token(@model)
    end

    # Returns the address string
    # (e.g bounce-newsletter-12-01ce26dc69094af9246ea7e7ce9970aff2b81cc9@bounce.example.com)
    #
    def address
      model_id = id_from_model(@model)
      model_name = normalized_model_name(@model)

      local_part = [Replyr.config.bounce_prefix, model_name, model_id, token].join("-")
      "#{local_part}@#{Replyr.config.bounce_host}"
    end
    alias_method :to_s, :address

  end
end