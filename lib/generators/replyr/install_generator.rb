module Replyr
  module Generators
    class InstallGenerator < Rails::Generators::Base
      def self.source_root
        File.dirname(__FILE__) + "/templates"
      end

      def copy_files
        copy_file "mailman_server", "script/mailman_server"
        copy_file "mailman_daemon", "script/mailman_daemon"
        template "replyr.rb.erb", "config/initializers/replyr.rb"
      end
    end
  end
end