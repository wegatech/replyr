module Replyr

  class Engine < Rails::Engine
    # setup logger
    initializer "replyr.logger" do
      Replyr.setup_logger
    end

    initializer "replyr.activerecord" do
      ActiveRecord::Base.send :extend, HandleReply::ClassMethods
    end

  end
end
