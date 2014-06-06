require 'mailman'
require 'email_reply_parser/email_reply_parser'
require "replyr/config"

require "replyr/address_builder"
require "replyr/reply_address"
require "replyr/bounce_address"

require "replyr/email"

require "replyr/handle_reply"
require "replyr/handle_bounce"
require 'replyr/engine'

module Replyr
  class << self
    attr_accessor :config, :logger

    def config
      @config ||= Replyr::Config.new
    end
    
    def setup_logger
      @logger = (defined?(Rails) && Rails.logger) ? Rails.logger : Logger.new(STDOUT)
    end
    
    # Regexp for reply addresses:
    # reply-comment-12-56-01ce26dc69094af9246ea7e7ce9970aff2b81cc9@reply.example.com
    #
    def reply_pattern
      /#{config.reply_prefix}-(?<model_name>[a-z,#]+)-(?<model_id>\d+)-(?<user_id>\d+)-(?<token>\S+)@#{config.reply_host}/
    end
    
    # Regexp for bounce addresses:
    # bounce-newsletter-12-01ce26dc69094af9246ea7e7ce9970aff2b81cc9@bounce.example.com
    #
    def bounce_pattern
      /#{config.bounce_prefix}-(?<model_name>[a-z,#]+)-(?<model_id>\d+)-(?<token>\S+)@#{config.bounce_host}/
    end
    
    # Regexp for bounce and reply addresses.
    # Use this as the Replyr route in your mailman-server.
    #
    def route
      /#{reply_pattern}|#{bounce_pattern}/
    end
    alias_method :address_pattern, :route
    
    def process(message)
      Replyr::Email.process(message)
    end
    
  end
end
