require_relative 'provider_elasticsearch'

class Chef
  class Provider
    class Elasticsearch
      class Smartos < Chef::Provider::Elasticsearch
        # Data directory
        # @return [String] Data directory
        def data_dir
          new_resource.data_dir || '/var/db/elasticsearch'
        end

        # Home directory
        # @return [String] Home directory
        def home_dir
          new_resource.home_dir || '/opt/local/elasticsearch'
        end

        # PID file directory
        # @return [String] Directory containing PID file
        def pid_dir
          '/var/tmp/elasticsearch'
        end

        # Working directory
        # @return [String] Working directory
        def work_dir
          new_resource.work_dir || '/var/tmp/elasticsearch'
        end

        # Elasticsearch Java Archive
        # @return [String] Elasticsearch JAR
        def jar_file
          ::File.join(home_dir, "lib/elasticsearch-#{version}.jar")
        end

        # SMF service template file
        # @return [String] SMF template location
        def service_file
          ::File.join(Chef::Config[:file_cache_path], service_name)
        end

        # User shell
        # @return [String] User shell location
        def shell_bin
          new_resource.shell || '/usr/bin/bash'
        end

        # Memory to allocate to JVM process
        # @return [Fixnum] Memory allocated to JVM process (MB)
        def jvm_heap_size
          ((50.0 / 100.0) * node[:memory][:total].to_f).to_i
        end

        action :create do
          # Provide discoverable cluster attributes
          set_cluster_address
          set_cluster_name
          set_cluster_type

          # Provision group
          group es_group do
            gid es_gid
          end

          # Provision user
          user es_user do
            home     home_dir
            shell    shell_bin
            uid      es_uid
            gid      es_group
            provider Chef::Provider::User::Solaris
          end

          # Create Project
          resource_control_project 'elastic' do
            comment        'Elasticsearch Service'
            users          es_user
            process_limits 'max-file-descriptor' => {
              'deny'  => true,
              'value' => '40000'
            }
          end

          # Provision required directories
          [data_dir, home_dir, log_dir, pid_dir, work_dir].each do |dir|
            directory dir do
              owner     es_user
              group     es_group
              mode      '0775'
              recursive true
            end
          end

          # Fetch install archive
          remote_file installer_target do
            action   :create_if_missing
            owner    'root'
            group    'root'
            mode     '0755'
            source   installer_source
            backup   false
            notifies :run, 'execute[decompress]', :immediately
          end

          # Decompress install archive
          execute 'decompress' do
            action   :nothing
            command  cmd_decompress
            notifies :run, 'execute[permissions]', :immediately
          end

          # Set appropriate permissions (recursive)
          execute 'permissions' do
            action :nothing
            command cmd_permissions
          end

          # Create SMF manifest
          template  service_file do
            owner    'root'
            group    'root'
            mode     '0644'
            source   "#{service_name}.service.erb"
            backup   false
            variables(
              class_dir:   class_dir,
              data_dir:    data_dir,
              home_dir:    home_dir,
              work_dir:    work_dir,
              jar_file:    jar_file,
              pid_file:    pid_file,
              config_file: config_file,
              user:        es_user,
              group:       es_group,
              jvm_heap:    jvm_heap_size,
              jvm_stack:   jvm_stack_size
            )
            notifies :run,  'execute[delete_manifest]', :immediately
            notifies :run,  'execute[import_manifest]', :immediately
          end

          # Define service
          service service_name do
            action   :nothing
            provider Chef::Provider::Service::Solaris
          end

          # Delete SMF manifest with update
          execute 'delete_manifest' do
            action  :nothing
            command manifest_delete
            only_if { manifest_exists? }
            returns [0,1]
          end

          # Import SMF manifest with update
          execute 'import_manifest' do
            action   :nothing
            command  manifest_import
            notifies :restart, "service[#{service_name}]"
          end

          # Create and populate config file
          template config_file do
            owner    'root'
            group    'root'
            mode     '0644'
            backup   false
            source   'elasticsearch.yml.erb'
            variables(
              address:   address,
              cluster:   cluster,
              http_port: http_port,
              marvel:    marvel,
              members:   members,
              multicast: multicast,
              modules:   modules,
              name:      node.name,
              t_port:    transport_port,
              type:      type,
              unicast:   unicast
            )
            notifies :restart, "service[#{service_name}]"
          end

          # Create and populdate logging config file
          template log_config_file do
            owner    'root'
            group    'root'
            mode     '0644'
            backup   false
            source   'logging.yml.erb'
            variables(
              log_file:  log_file,
              log_level: log_level
            )
            notifies :restart, "service[#{service_name}]"
          end

          # Install Marvel plugin
          elasticsearch_plugin 'elasticsearch/marvel/latest' do
            only_if { marvel }
          end

          #  Ensure service starts
          service service_name do
            action   :start
            provider Chef::Provider::Service::Solaris
          end
        end
      end
    end
  end
end
