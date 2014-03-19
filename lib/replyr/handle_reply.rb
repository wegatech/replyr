module Replyr
  module HandleReply

    def self.included(base)
      base.extend ClassMethods  
    end
  
    module ClassMethods 
    
      # Usage:
      # class Comment < ActiveRecord::Base
      #   handle_reply do |comment, user, text, files|
      #     Comment.create(body: text, author: user)
      #   end
      # end
      #
      def handle_reply(*options, &block)	
    		options = options.extract_options!

        define_method :handle_reply do |user, text, files = nil|
          block.call(self, user, text, files) 
        end
  
        define_method :reply_address_object_for_user do |user|
          ReplyAddress.new(self, user)
        end
        
        define_method :reply_address_for_user do |user|
          reply_address_object_for_user(user).to_s
        end

      end
    end

  end
end