require_relative 'provider_elasticsearch'

class Chef
  class Provider
    class Elasticsearch
      class Rhel < Chef::Provider::Elasticsearch
        # sysvinit options file
        # @return [String] Sysv init service options file
        def service_options_file
          ::File.join('/etc/sysconfig', current.service_name)
        end

        def action_install
          super

          directory '/etc/sysctl.d' do
            owner 'root'
            group 'root'
            mode  '0755'
          end

          template "/etc/sysctl.d/99-#{current.service_name}.conf" do
            owner    'root'
            group    'root'
            mode     '0644'
            cookbook 'elasticsearch_lwrp'
            source   'sysctl.conf.erb'
            backup   false
            variables(
              key:   'vm.max_map_count',
              value: current.resources[:memory][:map]
            )
            notifies :restart, "service[#{current.service_name}]"
          end

          execute 'reload_sysctl' do
            command cmd_reload_sysctl[:command]
            not_if  cmd_reload_sysctl[:guard]
            returns cmd_reload_sysctl[:expects]
          end

          template "/etc/security/limits.d/99-#{current.service_name}.conf" do
            owner    'root'
            group    'root'
            mode     '0644'
            source   'memlock.conf.erb'
            cookbook 'elasticsearch_lwrp'
            backup   false
            variables(
              limit: current.resources[:memory][:lock],
              user:  current.user
             )
            notifies :restart, "service[#{current.service_name}]"
          end

          template ::File.join('/etc/sysconfig', current.service_name) do
            owner    'root'
            group    'root'
            mode     '0644'
            cookbook 'elasticsearch_lwrp'
            source   'service.options.erb'
            backup   false
            variables(
              conf_dir:          ::File.dirname(current.config_file),
              data_dir:          current.data_dir,
              home_dir:          current.home_dir,
              log_dir:           current.log_dir,
              work_dir:          current.work_dir,
              conf_file:         current.config_file,
              java_heap:         java_heap_size,
              java_stack:        current.java_stack,
              max_locked_memory: current.resources[:memory][:lock],
              max_memory_map:    current.resources[:memory][:map],
              max_open_files:    current.resources[:files][:open],
              user:              current.user
            )
            notifies :restart, "service[#{current.service_name}]"
          end

          template service_file do
            owner     'root'
            group     'root'
            mode      '0755'
            cookbook  'elasticsearch_lwrp'
            source    'service.erb'
            backup    false
            variables(
              config: current.config_file,
              pid:    current.pid_file,
              exec:   ::File.join(current.home_dir, 'bin/elasticsearch')
            )
          end

          service current.service_name do
            action   [:enable, :start]
            supports restart: true, status: true
          end
        end
      end
    end
  end
end
