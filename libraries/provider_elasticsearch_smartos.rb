require_relative 'provider_elasticsearch'

class Chef
  class Provider
    class Elasticsearch
      class Smartos < Chef::Provider::Elasticsearch
        include ::Elasticsearch::Helpers

        # Class path
        # @return [String] Class path
        def class_dir
          ::File.join(current.home_dir, 'lib')
        end

        # JAR file location
        # @return [String] Elasticsearch JAR
        def jar_file
          ::File.join(current.home_dir, "lib/elasticsearch-#{current.version}.jar")
        end

        def action_install
          super

          # SmartOS resource management project
          resource_control_project 'elastic' do
            comment        'Elasticsearch Service'
            users          current.user
            process_limits 'max-file-descriptor' => {
              'deny'  => true,
              'value' => current.resources[:files][:open]
            }
            notifies :restart, "service[#{node[:elasticsearch][:service]}]"
          end

          # SMF manifest
          template  service_file do
            owner    'root'
            group    'root'
            mode     '0644'
            cookbook 'elasticsearch'
            source   'service.erb'
            backup   false
            variables(
              class_dir:    class_dir,
              data_dir:     current.data_dir,
              home_dir:     current.home_dir,
              log_dir:      current.log_dir,
              work_dir:     current.work_dir,
              jar_file:     jar_file,
              config:       current.config_file,
              pid:          current.pid_file,
              user:         current.user,
              group:        current.group,
              java_heap:    java_heap_size,
              java_home:    java_home,
              java_stack:   current.java_stack
            )
            notifies :run,     'execute[delete_manifest]', :immediately
            notifies :run,     'execute[import_manifest]', :immediately
            notifies :restart, "service[#{node[:elasticsearch][:service]}]"
          end

          execute 'delete_manifest' do
            action  :nothing
            command manifest_delete
            only_if { manifest_exists? }
            returns [0,1]
          end

          execute 'import_manifest' do
            action   :nothing
            command  manifest_import
            notifies :restart, "service[#{current.service_name}]"
          end

          service current.service_name do
            action   :start
            supports restart: true
            provider Chef::Provider::Service::Solaris
          end
        end
      end
    end
  end
end
