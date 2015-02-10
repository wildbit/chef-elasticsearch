require_relative 'provider_elasticsearch'

class Chef
  class Provider
    class Elasticsearch
      class Rhel < Chef::Provider::Elasticsearch
        # Data directory
        # @return [String] Data directory
        def data_dir
          new_resource.data_dir || '/var/lib/elasticsearch'
        end

        # Home directory
        # @return [String] Home directory
        def home_dir
          new_resource.home_dir || '/opt/elasticsearch'
        end

        # PID file directory
        # @return [String] Directory containing PID file
        def pid_dir
          '/var/run/elasticsearch'
        end

        # Working directory
        # @return [String] Working directory
        def work_dir
          new_resource.work_dir || '/tmp/elasticsearch'
        end

        # Sysv init definition
        # @return [String] Sysv init service file
        def service_file
          ::File.join('/etc/init.d', service_name)
        end

        # Sysv init options file
        # @return [String] Sysv init service options file
        def service_options_file
          ::File.join('/etc/sysconfig', service_name)
        end

        # Executable wrapper script
        # @return [String] Elasticsearch executable wrapper script
        def exec_bin
          ::File.join(home_dir, 'bin/elasticsearch')
        end

        # Elasticsearch plugin executable
        # @return [String] Elasticsearch plugin executable
        def plugin_bin
          ::File.join(home_dir, 'bin/plugin')
        end

        # User shell
        # @return [String] User shell location
        def shell_bin
          new_resource.shell || '/bin/bash'
        end

        # Memory to allocate to JVM process
        # @return [Fixnum] Memory allocated to JVM process (MB)
        def jvm_heap_size
          ((((50.0 / 100.0) * node[:memory][:total].to_f)).to_i / 1000)
        end

        action :create do
          # Provide discoverable cluster attributes
          set_cluster_address
          set_cluster_name
          set_cluster_type

          # Create kernel options include directory
          directory '/etc/sysctl.d' do
            owner 'root'
            group 'root'
            mode  '0755'
          end

          # Set user memory mapped file limit
          template "/etc/sysctl.d/99-#{service_name}.conf" do
            owner    'root'
            group    'root'
            mode     '0644'
            source   'sysctl.conf.erb'
            backup   false
            cookbook 'sysctl'
            variables(
              key:   'vm.max_map_count',
              value: max_memory_map
            )
            notifies :restart, "service[#{service_name}]"
          end

          execute 'reload_sysctl' do
            command cmd_reload_sysctl[:command]
            not_if  cmd_reload_sysctl[:guard]
            returns cmd_reload_sysctl[:expects]
          end

          # Set user memory lock limit
          template "/etc/security/limits.d/99-#{service_name}.conf" do
            owner    'root'
            group    'root'
            mode     '0644'
            source   'memlock.conf.erb'
            cookbook 'elasticsearch_lwrp'
            backup   false
            variables(
              limit: max_locked_memory,
              user:  es_user
             )
            notifies :restart, "service[#{service_name}]"
          end

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

          # Create init script options file
          template service_options_file do
            owner    'root'
            group    'root'
            mode     '0644'
            cookbook 'elasticsearch_lwrp'
            source   'service.options.erb'
            backup   false
            variables(
              conf_dir:          config_dir,
              data_dir:          data_dir,
              home_dir:          home_dir,
              log_dir:           log_dir,
              work_dir:          work_dir,
              conf_file:         config_file,
              jvm_heap_size:     jvm_heap_size,
              jvm_stack_size:    jvm_stack_size,
              max_locked_memory: max_locked_memory,
              max_memory_map:    max_memory_map,
              max_open_files:    max_open_files,
              user:              es_user
            )
            notifies :restart, "service[#{service_name}]"
          end

          # Create Init script
          template  service_file do
            owner    'root'
            group    'root'
            mode     '0755'
            cookbook 'elasticsearch_lwrp'
            source   "#{service_name}.service.erb"
            backup   false
            variables(
              class_dir:   class_dir,
              data_dir:    data_dir,
              home_dir:    home_dir,
              pid_file:    pid_file,
              config_file: config_file,
              exec_file:   exec_bin,
              user:        es_user,
              group:       es_group,
              jvm_heap:    jvm_heap_size,
              jvm_stack:   jvm_stack_size
            )
            notifies :restart, "service[#{service_name}]"
          end

          # Start service
          service service_name do
            action   [:enable, :start]
          end

          # Create and populate config file
          template config_file do
            owner    'root'
            group    'root'
            mode     '0644'
            cookbook 'elasticsearch_lwrp'
            source   'elasticsearch.yml.erb'
            backup   false
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
            owner     'root'
            group     'root'
            mode      '0644'
            cookobook 'elasticsearch_lwrp'
            backup    false
            source    'logging.yml.erb'
            variables(
              log_file:  log_file,
              log_level: log_level
            )
            notifies :restart, "service[#{service_name}]"
          end

          # Install Marvel plugin
          elasticsearch_plugin 'elasticsearch/marvel/latest' do
            plugin_binary plugin_bin
            only_if       { marvel }
          end
        end
      end
    end
  end
end
