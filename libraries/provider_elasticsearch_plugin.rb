require 'chef/resource'
require 'chef/provider'

class Chef
  class Provider
    class ElasticsearchPlugin < Chef::Provider
      attr_reader :current_resource, :new_resource
      include Chef::Mixin::ShellOut

      def action_install
        unless current_resource.installed
          cmd_install = "#{current_resource.plugin_binary} -s -i #{current_resource.plugin_name}"

          response = shell_out(cmd_install)
          if response.exitstatus > 0
            Chef::Log.fatal("Unable to install #{current_resource.plugin_name}")
            raise
          else
            true
          end
        end
      end

      def action_remove
        if current_resource.installed
          cmd_remove = "#{current_resource.plugin_binary} -s -r #{parsed_name}"
          
          response = shell_out(cmd_remove)
          if response.exitstatus > 0
            Chef::Log.fatal("Unable to remove #{parsed_name}")
            raise
          else
            true
          end
        end
      end

      def load_current_resource
        @current_resource = Chef::Resource::ElasticsearchPlugin.new(new_resource.name)
        current_resource.plugin_binary  new_resource.plugin_binary
        current_resource.plugin_name    new_resource.plugin_name
        current_resource.plugin_version new_resource.plugin_version
        
        current_resource.installed = installed_plugins.include?(parsed_name)
        current_resource
      end

      # Plugin name
      def parsed_name
        pattern = Regexp.new('(\w+)\/(\w+)\/(\w+)')

        matched = current_resource.plugin_name.match(pattern)
        matched ? matched[2] : current_resource.plugin_name
      end

      # Plugin version
      def parsed_version
        pattern = Regexp.new('(\w+)\/(\w+)\/(\w+)')
        
        matched = current_resource.plugin_name.match(pattern)
        matched ? matched[3] : current_resource.plugin_version
      end

      def installed_plugins
        @installed_plugins ||= begin
          output = shell_out!("#{current_resource.plugin_binary} -l").stdout

          # Format output
          output = output.split("\n").select { |result| result.include?('-') }
          output.map! { |result| result.gsub!(/(-|\s+)/, '') }

          output
        end
      end
    end
  end
end
