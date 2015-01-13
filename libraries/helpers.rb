module Opscode
  module Elasticsearch
    module Helpers
      include Chef::DSL::DataQuery
      include Chef::Mixin::ShellOut

      # IP address to bind to
      # @return [String]
      def address
        interface = new_resource.interface || value_for_platform_family(rhel: 'eth1', smartos: 'net1')
        address   = interfaces[interface]

        interfaces.keys.include?(interface) ? interfaces[interface] : '127.0.0.1'
      end

      # Installation archive name
      # @return [String] Installation archive
      def installer
        "elasticsearch-#{version}.tar.gz"
      end

      # Installation archive source
      # @return [String] Installation archive source
      def installer_source
        "https://download.elasticsearch.org/elasticsearch/elasticsearch/#{installer}"
      end

      # Installation archive local path
      # @return [String] Installation archive location
      def installer_target
        File.join(Chef::Config[:file_cache_path], installer)
      end

      def interfaces
        output = {}

        # Pay no mind to loopback devices
        interfaces  = node.network.interfaces.keys.reject do |iface| 
          iface.match('^lo')
        end

        # Map interface to address
        interfaces.each do |iface|
          addr = node[:network][:interfaces][iface].addresses.keys.select do |addr|
            addr.match('^(\d{1,3}\.?){4}$')
          end
          output[iface] = addr.first
        end
        output
      end

      # Collection of cluster members
      # @return [Array] Cluster members 
      # XXX - DRY this
      def members
        output = {}
        port   = transport_port

        query = ["elasticsearch_cluster:#{cluster}"]
        query << "chef_environment:#{node.chef_environment}"
        query = query.join(' AND ')

        response = search(:node, query)

        # Discover all non-marvel cluster members
        output[:active] = response.reject do |member|
          member.elasticsearch.type == 'marvel' rescue []
        end.map! do |member|
          addr = node.elasticsearch.address rescue node.ipaddress
          "#{addr}:#{port}"
        end.join(',')

        # Discovery marvel cluster member(s)
        output[:marvel] = response.select do |member|
          member.elasticsearch.type == 'marvel' rescue []
        end.map! { |mem| "#{mem.elasticsearch.address}:#{port}" }.join(',')

        output
      end

      # Configuration file
      # @return [String] Location of config file
      def config_file
        File.join(config_dir, 'elasticsearch.yml')
      end

      # Logging configuration file
      # @return [String] Log configuration file
      def log_config_file
        File.join(config_dir, 'logging.yml')
      end
      
      # Log output file
      # @return [String] Logging output file
      def log_file
        File.join(log_dir, 'elasticsearch.log')
      end

      # PID file
      # @return [String] PID file
      def pid_file
        File.join(pid_dir, 'elasticsearch.pid')
      end

      # Command used to extract source archive
      # @return [String] Source extraction command
      def cmd_decompress
        "tar -C #{home_dir} -xf #{installer_target} --strip-components 1"
      end

      # Command used to update install file permissions
      # @return [String] Installation file permissions command
      def cmd_permissions
        "chown -R #{es_user}:#{es_group} #{home_dir}"
      end

      def cmd_reload_sysctl
        {
          command: "/sbin/sysctl -p /etc/sysctl.d/99-#{service_name}.conf",
          expects: [0, 255],
          guard:   "[ $(/sbin/sysctl -n vm.max_map_count) == #{max_memory_map} ]"
        }
      end

      def manifest_exists?
        response = shell_out("svcs -l elasticsearch")
        response.exitstatus > 0 ? false : true
      end

      # Command & conditional to delete SMF manifest
      def manifest_delete
        "/usr/sbin/svccfg delete -f #{service_name}"
      end

      # Command & conditional to import SMF manifest
      def manifest_import
         "/usr/sbin/svccfg import #{service_file}"
      end

      def jvm_stack_size
        '256k'
      end

      # Set node attribute for address
      # XXX - DRY
      def set_cluster_address
        current_address = node[:elasticsearch][:address] rescue nil
        
        if (current_address.nil? || current_address != address)
          node.normal[:elasticsearch][:address] = address
          node.save
        end
        true
      end

      # Set node attribute for cluster name
      # XXX - DRY
      def set_cluster_name
        current_name = node[:elasticsearch][:cluster] rescue nil
        
        if (current_name.nil? || current_name != cluster)
          node.normal[:elasticsearch][:cluster] = cluster
          node.save
        end
        true
      end

      # Set node attribute for cluster type
      # XXX - DRY 
      def set_cluster_type
        current_type = node[:elasticsearch][:type] rescue nil
        
        if (current_type.nil? || current_type != type)
          node.normal[:elasticsearch][:type] = type
          node.save
        end
        true
      end

      # Port accepting inter-member connections. 
      # @return [String] Transport port
      def transport_port
        port = new_resource.transport_port || '9300-9400'
        port = port.to_s

        port.match('^\d+-\d+$') ? port.split('-').first : port
      end

      # Version of Elasticsearch to manage
      # @return [String] Elasticsearch version
      def version
        new_resource.version || '1.4.2'
      end
    end
  end
end
