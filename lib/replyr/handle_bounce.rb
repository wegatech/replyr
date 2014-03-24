module Replyr
  module HandleBounce

    def self.included(base)
      base.extend ClassMethods  
    end
  
    module ClassMethods 
    
      # Usage:
      # class Comment < ActiveRecord::Base
      #   handle_bounce do |comment, email|
      #     # your custom code (e.g. mark email as invalid)
      #   end
      # end
      #
      def handle_bounce(*options, &block)	
    		options = options.extract_options!

        define_method :handle_bounce do |email|
          block.call(self, email) 
        end
  
        define_method :bounce_address_object do
          BounceAddress.new(self)
        end
        
        define_method :bounce_address do
          bounce_address_object.to_s
        end
      end
    end

  end
end