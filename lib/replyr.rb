require 'mailman'
require "replyr/config"
require "replyr/reply_email"
require "replyr/reply_address"
require "replyr/handle_reply"
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
    
    def address_pattern
      "#{config.prefix}-%model_name%-%model_id%-%user_id%-%token%@#{config.host}"
    end
    
  end
end
