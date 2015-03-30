require          'chef/mixin/shell_out'
require_relative 'provider_elasticsearch'

class Chef
  class Provider
    class Elasticsearch < Chef::Provider
      attr_reader :current

      include ::Chef::DSL::Recipe
      include ::Chef::Mixin::ShellOut
      include ::Elasticsearch::Helpers

      def action_install
        package java_package

        group current.group do
          gid current.gid
        end

        user current.user do
          group   current.group
          gid     current.group
          uid     current.uid
          comment 'Elasticsearch'
          shell   '/usr/bin/false'
        end

        %w(data_dir home_dir log_dir plugin_dir work_dir).each do |dir|
          dir = current.send(dir.to_sym)

          directory dir do
            owner     current.user
            group     current.group
            mode      '0775'
            recursive true
          end
        end

        remote_file installer_target do
          owner    'root'
          group    'root'
          mode     '0755'
          checksum current.checksum
          source   current.source
          backup   false
          notifies :run, 'execute[decompress]', :immediately
        end

        execute 'decompress' do
          action   :nothing
          command  cmd_decompress
          notifies :run, 'execute[permissions]', :immediately
        end

        execute 'permissions' do
          action :nothing
          command cmd_permissions
        end

        directory ::File.dirname(current.config_file) do
          owner     'root'
          group     'root'
          mode      '0755'
          recursive true
        end

        template current.config_file do
          owner    'root'
          group    'root'
          mode     '0644'
          cookbook 'elasticsearch_lwrp'
          backup   false
          variables(
            cluster:        current.cluster,
            host:           address,
            http:           current.http,
            http_port:      current.http_port,
            members:        members,
            marvel:         current.marvel,
            mlockall:       current.mlockall,
            modules:        current.modules,
            multicast:      current.multicast,
            name:           node.name,
            transport_port: current.transport_port,
            type:           current.type,
            unicast:        current.unicast
          )
          notifies :restart, "service[#{node[:elasticsearch][:service]}]"
        end

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
          notifies :restart, "service[#{node[:elasticsearch][:service]}]"
        end

        directory ::File.dirname(current.pid_file) do
          owner    current.user
          group    current.group
          mode     '0755'
          recursive true
        end

        # Marvel plugin
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
        current.plugin_dir     new_resource.plugin_dir
        current.work_dir       new_resource.work_dir
        current.cluster        new_resource.cluster
        current.checksum       new_resource.checksum
        current.config_file    new_resource.config_file
        current.gid            new_resource.gid
        current.group          new_resource.group
        current.http           new_resource.http
        current.http_port      new_resource.http_port
        current.interface      new_resource.interface
        current.java_heap      new_resource.java_heap
        current.java_home      new_resource.java_home
        current.java_version   new_resource.java_version
        current.java_stack     new_resource.java_stack
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
