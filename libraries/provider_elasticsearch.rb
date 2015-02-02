require          'chef/provider/lwrp_base'
require_relative 'helpers'

class Chef
  class Provider
    class Elasticsearch < LWRPBase
      include Opscode::Elasticsearch::Helpers

      use_inline_resources

      def whyrun_supported?
        true
      end

      # Interface to bind to for connections
      # @return [String] Interface to bind to
      def interface
        new_resource.address || 'net1'
      end

      # Cluster name
      # @return [string] Cluster name
      def cluster
        new_resource.cluster || 'development'
      end

      # User to execute process as
      # @return [String] Elasticsearch user
      def es_user
        new_resource.user || 'elasticsearch'
      end

      # Group to execute process as
      # @return [String] Elasticsearch group
      def es_group
        new_resource.group || 'elasticsearch'
      end

      # UID of group
      # @return [String] User UID
      def es_uid
        new_resource.uid || '700'
      end

      # GID of user
      # @return [String] User GID
      def es_gid
        new_resource.gid || '700'
      end

      # Directory containing Java class files
      # @return [String] Java class files directory
      def class_dir
        ::File.join(home_dir, 'lib')
      end

      # Directory containing configuration files
      # @return [String] Configuration directory
      def config_dir
        ::File.join(home_dir, 'config')
      end

      # Directory containing log files
      # @return [String] Log file directory
      def log_dir
        new_resource.log_dir || '/var/log/elasticsearch'
      end

      # Directory containing installed plugins
      # @return [String] Plugin directory
      def plugin_dir
        ::File.join(home_dir, 'plugins')
      end

      # Port accepting HTTP connections
      # @return [String] HTTP port
      def http_port
        new_resource.http_port || '9200-9300'
      end

      # Logging verbosity
      # @return [String] Logging verbosity
      def log_level
        new_resource.log_level || 'DEBUG'
      end

      # Marvel monitoring agent
      # @return [FalseClass, NilClass, TrueClass] Marvel agent
      def marvel
        new_resource.marvel || true
      end

      # Maximum amount of locked memory
      # @return [String] Locked memory limit
      def max_locked_memory
        new_resource.max_locked_memory || 'unlimited'
      end

      # Maximum count of memory mapped files
      # @return [Fixnum,String] Maximum memory mapped files
      def max_memory_map
        new_resource.max_memory_map || '262144'
      end

      # Maximum number of files open
      # @return [String] Maximum allowed number of open files
      def max_open_files
        new_resource.max_open_files || '65535'
      end

      # Modules
      # @return [Hash] Common module defaults
      def modules
        default_modules = {
          'discovery.zen.ping.timeout'                    => '60s',
          'discovery.zen.fd.ping_interval'                => '5s',
          'discovery.zen.fd.ping_retries'                 => '5',
          'discovery.zen.fd.ping_timeout'                 => '60s',
          'index.merge.policy.max_merge_at_once'          => '8',
          'index.merge.policy.max_merge_at_once_explicit' => '25',
          'index.merge.scheduler.max_thread_count'        => '1',
          'index.refresh_interval'                        => '5s',
          'index.translog.flush_threshold_period'         => '5s',
          'indices.memory.index_buffer_size'              => '15%',
          'transport.tcp.connect_timeout'                 => '90s'
        }
        all_modules = default_modules.merge(new_resource.modules)

        # Delete modules exposed via resource
        %w[
           discovery.zen.ping.multicast.enabled
           discovery.zen.ping.unicast.hosts
           transport.tcp.port
        ].each { |mod| all_modules.delete!(mod) if default_modules.has_key?(mod) }

        all_modules
      end

      # Multicast node discovery
      # @return [FalseClass,TrueClass] Multicast discovery
      def multicast
        new_resource.multicast || false
      end

      # Port accepting HTTP connections
      # @return [String] HTTP port
      def http_port
        new_resource.http_port || '9200'
      end

      # Service name
      # @return [String] Service name
      def service_name
        new_resource.service_name || 'elasticsearch'
      end

      # Type of Elasticsearch member
      # @return [String] Member type
      def type
        new_resource.type || 'data'
      end

      # Unicast node discovery
      # @return [FalseClass,TrueClass] Unicast discovery
      def unicast
        new_resource.unicast || true
      end

      action :create do
      end

      action :create do
      end
    end
  end
end
