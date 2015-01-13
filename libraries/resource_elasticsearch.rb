require 'chef/resource'

class Chef
  class Resource
    class Elasticsearch < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @action          = :create
        @allowed_actions = [:create, :delete]
        @resource_name   = :elasticsearch
      end

      # Cluster name
      def cluster(arg = nil)
        set_or_return(
          :cluster,
          arg,
          kind_of: String
        )
      end

      # Data directory
      def data_dir(arg = nil)
        set_or_return(
          :data_dir,
          arg,
          kind_of: String
        )
      end

      # Home directory
      def home_dir(arg = nil)
        set_or_return(
          :home_dir,
          arg,
          kind_of: String
        )
      end

      # Logging directory
      def log_dir(arg = nil)
        set_or_return(
          :log_dir,
          arg,
          kind_of: String
        )
      end

      # Working directory
      def work_dir(arg = nil)
        set_or_return(
          :work_dir,
          arg,
          kind_of: String
        )
      end

      # HTTP port (API)
      def http_port(arg = nil)
        set_or_return(
          :http_port,
          arg,
          kind_of: [Fixnum, String]
        )
      end

      def interface(arg = nil)
        set_or_return(
          :interface,
          arg,
          kind_of: String
        )
      end

      # Log verbosity
      def log_level(arg = nil)
        set_or_return(
          :log_level,
          arg,
          kind_of: String
        )
      end

      # Enable/disable Marvel agent 
      def marvel(arg = nil)
        set_or_return(
          :marvel,
          arg,
          kind_of: [FalseClass, NilClass, TrueClass]
        )
      end

      # Maximum amount of locked memory
      def max_locked_memory(arg = nil)
        set_or_return(
          :max_locked_memory,
          arg,
          kind_of: String
        )
      end

      # Maximum memory mapped files
      def max_memory_map(arg = nil)
        set_or_return(
          :max_memory_map,
          arg,
          kind_of: [Fixnum, String]
        )
      end

      # Maximum allowed open files 
      def max_open_files(arg = nil)
        set_or_return(
          :max_open_files,
          arg,
          kind_of: String
        )
      end

      # Cluster members
      def members(arg = nil)
        set_or_return(
          :members,
          arg,
          kind_of: [Array, String],
        )
      end

      # Modules
      def modules(arg = nil)
        set_or_return(
          :modules,
          arg,
          default: {},
          kind_of: Hash
        )
      end

      # Enable/disable multicast discovery
      def multicast(arg = nil)
        set_or_return(
          :multicast,
          arg,
          kind_of: [FalseClass, NilClass, TrueClass]
        )
      end

      # User shell
      def shell(arg = nil)
        set_or_return(
          :shell,
          arg,
          kind_of: String
        )
      end

      # Service name
      def service_name(arg = nil)
        set_or_return(
          :service_name,
          arg,
          kind_of: String
        )
      end

      # Transport port
      def transport_port(arg = nil)
        set_or_return(
          :transport_port,
          arg,
          kind_of: [Fixnum, String]
        )
      end

      # Member type
      def type(arg = nil)
        set_or_return(
          :type,
          arg,
          equal_to: %w(client data master marvel)
        )
      end

      # Enable/disable unicast discovery
      def unicast(arg = nil)
        set_or_return(
          :unicast,
          arg,
          kind_of: [FalseClass,NilClass,TrueClass]
        )
      end

      # User process runs as
      def user(arg = nil)
        set_or_return(
          :user,
          arg,
          kind_of: String
        )
      end

      # Group process runs as
      def group(arg = nil)
        set_or_return(
          :group,
           arg,
           kind_of: String
        )
      end

      # UID of user
      def uid(arg = nil)
        set_or_return(
          :uid,
           arg,
           kind_of: [Fixnum, String]
        )
      end

      # GID of group
      def gid(arg = nil)
        set_or_return(
          :gid,
          arg,
          kind_of: String
        )
      end

      # Version managed
      def version(arg = nil)
        set_or_return(
          :version,
          arg,
          kind_of:        [Fixnum, Float, String],
          name_attribute: true            
        )
      end
    end
  end
end
