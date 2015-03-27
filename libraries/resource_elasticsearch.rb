require 'chef/resource'

class Chef
  class Resource
    class Elasticsearch < Chef::Resource
      def initialize(name, run_context = nil)
        super
        @action          = :install
        @allowed_actions = [:install, :remove]
        @resource_name   = :elasticsearch
      end

      def checksum(arg = nil)
        set_or_return(
          :checksum,
          arg,
          default: lazy { node[:elasticsearch][:checksum] }
        )
      end

      def cluster(arg = nil)
        set_or_return(
          :cluster,
          arg,
          default: lazy { node[:elasticsearch][:cluster] }
        )
      end

      def config_file(arg = nil)
        set_or_return(
          :config_file,
          arg,
          default: lazy { node[:elasticsearch][:file][:config] }
        )
      end

      def data_dir(arg = nil)
        set_or_return(
          :data_dir,
          arg,
          default: lazy { node[:elasticsearch][:dir][:data] }
        )
      end

      def home_dir(arg = nil)
        set_or_return(
          :home_dir,
          arg,
          default: lazy { node[:elasticsearch][:dir][:home] }
        )
      end

      def http(arg = nil)
        set_or_return(
          :http,
          arg,
          default: lazy { node[:elasticsearch][:http] }
        )
      end

      def java_heap(arg = nil)
        set_or_return(
          :java_heap,
          arg,
          default: nil,
          kind_of: [Fixnum, String]
        )
      end

      def java_home(arg = nil)
        set_or_return(
          :java_home,
          arg,
          default: lazy { node[:elasticsearch][:java][:home] }
        )
      end

      def java_stack(arg = nil)
        set_or_return(
          :java_stack,
          arg,
          default: lazy { node[:elasticsearch][:java][:stack] }
        )
      end

      def java_version(arg = nil)
        set_or_return(
          :java_version,
          arg,
          default: lazy { node[:elasticsearch][:java][:version] }
        )
      end

      def log_config(arg = nil)
        set_or_return(
          :log_config,
          arg,
          default: lazy  { node[:elasticsearch][:log][:config] }
        )
      end

      def log_dir(arg = nil)
        set_or_return(
          :log_dir,
          arg,
          default: lazy { node[:elasticsearch][:dir][:log] }
        )
      end

      def log_file(arg = nil)
        set_or_return(
          :log_file,
          arg,
          default: lazy { node[:elasticsearch][:log][:file] }
        )
      end

      def work_dir(arg = nil)
        set_or_return(
          :work_dir,
          arg,
          default: lazy { node[:elasticsearch][:dir][:work] }
        )
      end

      def http_port(arg = nil)
        set_or_return(
          :http_port,
          arg,
          default: lazy { node[:elasticsearch][:port][:http] }
        )
      end

      def interface(arg = nil)
        set_or_return(
          :interface,
          arg,
          default: lazy { node[:elasticsearch][:interface] }
        )
      end

      def log_level(arg = nil)
        set_or_return(
          :log_level,
          arg,
          default: lazy { node[:elasticsearch][:log][:level] }
        )
      end

      def marvel(arg = nil)
        set_or_return(
          :marvel,
          arg,
          default: lazy { node[:elasticsearch][:marvel] }
        )
      end

      def members(arg = nil)
        set_or_return(
          :members,
          arg,
          kind_of: [Array, String]
        )
      end

      def mlockall(arg = nil)
        set_or_return(
          :mlockall,
          arg,
          default: lazy { node[:elasticsearch][:mlockall] }
        )
      end

      def modules(arg = nil)
        set_or_return(
          :modules,
          arg,
          default: lazy { node[:elasticsearch][:modules] }
        )
      end

      def multicast(arg = nil)
        set_or_return(
          :multicast,
          arg,
          default: lazy { node[:elasticsearch][:multicast] }
        )
      end

      def pid_file(arg = nil)
        set_or_return(
          :pid_file,
          arg,
          default: lazy { node[:elasticsearch][:file][:pid] }
        )
      end

      def plugin_dir(arg = nil)
        set_or_return(
          :plugin_dir,
          arg,
          default: lazy { node[:elasticsearch][:dir][:plugin] }
        )              
      end

      def resources(arg = nil)
        set_or_return(
          :resources,
          arg,
          default: lazy { node[:elasticsearch][:resources] }
        )
      end

      def service_name(arg = nil)
        set_or_return(
          :service_name,
          arg,
          default: lazy { node[:elasticsearch][:service] }
        )
      end

      def source(arg = nil)
        set_or_return(
          :source,
          arg,
          default: lazy { node[:elasticsearch][:source] }
        )
      end

      def transport_port(arg = nil)
        set_or_return(
          :transport_port,
          arg,
          default: lazy { node[:elasticsearch][:port][:transport] }
        )
      end

      def type(arg = nil)
        set_or_return(
          :type,
          arg,
          default: lazy { node[:elasticsearch][:type] }
        )
      end

      def unicast(arg = nil)
        set_or_return(
          :unicast,
          arg,
          default: lazy { node[:elasticsearch][:unicast] }
        )
      end

      def user(arg = nil)
        set_or_return(
          :user,
          arg,
          default: lazy { node[:elasticsearch][:user][:name] }
        )
      end

      def group(arg = nil)
        set_or_return(
          :group,
           arg,
           default: lazy { node[:elasticsearch][:group][:name] }
        )
      end

      def uid(arg = nil)
        set_or_return(
          :uid,
           arg,
           default: lazy { node[:elasticsearch][:user][:uid] }
        )
      end

      def gid(arg = nil)
        set_or_return(
          :gid,
          arg,
          default: lazy { node[:elasticsearch][:group][:gid] }
        )
      end

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
