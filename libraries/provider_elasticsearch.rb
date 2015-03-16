require          'chef/provider'
require          'chef/dsl/recipe'
require_relative 'helpers'

class Chef
  class Provider
    class Elasticsearch < Chef::Provider
      attr_reader :current

      include ::Chef::DSL::Recipe
      include ::Elasticsearch::Helpers

      def shared_actions
        # Install Java
        package java_package

        # Create group
        group current.group do
          gid current.gid
        end

        # Create user
        user current.user do
          group   current.group
          gid     current.group
          uid     current.uid
          comment 'Elasticsearch'
          shell   '/usr/bin/false'
        end

        # Create required directories
        %w(data_dir home_dir log_dir work_dir).each do |dir|
          dir = current.send(dir.to_sym)

          directory dir do
            owner     current.user
            group     current.group
            mode      '0775'
            recursive true
          end
        end

        # Fetch installation archive
        remote_file installer_target do
          owner    'root'
          group    'root'
          mode     '0755'
          checksum current.checksum
          source   current.source
          backup   false
          notifies :run, 'execute[decompress]', :immediately
        end

        # Decompress installation archive
        execute 'decompress' do
          action   :nothing
          command  cmd_decompress
          notifies :run, 'execute[permissions]', :immediately
        end

        # Set installation permissions
        execute 'permissions' do
          action :nothing
          command cmd_permissions
        end

        # Create configuration directory
        directory ::File.dirname(current.config_file) do
          owner     'root'
          group     'root'
          mode      '0755'
          recursive true
        end

        # Create & populate configuration file
        template current.config_file do
          owner    'root'
          group    'root'
          mode     '0644'
          cookbook 'elasticsearch_lwrp'
          backup   false
          variables(
            cluster:        current.cluster,
            host:           current.listen,
            http:           current.http,
            http_port:      current.http_port,
            members:        cluster_members,
            marvel:         current.marvel,
            mlockall:       current.mlockall,
            modules:        current.modules,
            multicast:      current.multicast,
            name:           node.name,
            transport_port: current.transport_port,
            type:           current.type,
            unicast:        current.unicast
          )
        end

        # Log configuration
        template current.log_config do
          owner    current.user
          group    current.group
          mode     '0644'
          cookbook 'elasticsearch_lwrp'
          backup   false
          variables(
            log_file:  current.log_file,
            log_level: current.log_level
          )
        end

        # PID file directory
        directory ::File.dirname(current.pid_file) do
          owner    current.user
          group    current.group
          mode     '0755'
          recursive true
        end

        # Install Marvel monitoring plugin
        elasticsearch_plugin 'elasticsearch/marvel/latest' do
          plugin_binary ::File.join(current.home_dir, 'bin/plugin')
          only_if       { current.marvel }
        end
      end

      def load_current_resource
        @current = Chef::Resource::Elasticsearch.new(new_resource.name)
        current.data_dir       new_resource.data_dir
        current.home_dir       new_resource.home_dir
        current.log_dir        new_resource.log_dir
        current.work_dir       new_resource.work_dir
        current.cluster        new_resource.cluster
        current.checksum       new_resource.checksum
        current.config_file    new_resource.config_file
        current.gid            new_resource.gid
        current.group          new_resource.group
        current.http           new_resource.http
        current.http_port      new_resource.http_port
        current.java_heap      new_resource.java_heap
        current.java_home      new_resource.java_home
        current.java_version   new_resource.java_version
        current.java_stack     new_resource.java_stack
        current.listen         new_resource.listen
        current.log_config     new_resource.log_config
        current.log_file       new_resource.log_file
        current.log_level      new_resource.log_level
        current.marvel         new_resource.marvel
        current.mlockall       new_resource.mlockall
        current.members        new_resource.members
        current.modules        new_resource.modules
        current.multicast      new_resource.multicast
        current.pid_file       new_resource.pid_file
        current.resources      new_resource.resources
        current.service_name   new_resource.service_name
        current.source         new_resource.source
        current.transport_port new_resource.transport_port
        current.type           new_resource.type
        current.user           new_resource.user
        current.uid            new_resource.uid
        current.unicast        new_resource.unicast
        current.version        new_resource.version

        current
      end
    end
  end
end
